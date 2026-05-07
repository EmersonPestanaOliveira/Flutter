import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/observability/telemetry.dart';
import '../../data/services/ocorrencia_service.dart';
import '../../domain/usecases/create_ocorrencia_usecase.dart';
import 'ocorrencia_form_state.dart';

/// Cubit responsável por toda a lógica do formulário de ocorrência.
///
/// A UI (OcorrenciaFormScreen) passa a ser um observador puro: recebe
/// [OcorrenciaFormState] e chama métodos públicos deste cubit.
///
/// Responsabilidades:
/// - Capturar/parar gravação de áudio;
/// - Selecionar imagens/documentos;
/// - Obter localização atual;
/// - Validar campos obrigatórios;
/// - Delegar criação ao [CreateOcorrenciaUseCase];
/// - Emitir estado adequado para cada etapa.
class OcorrenciaFormCubit extends Cubit<OcorrenciaFormState> {
  OcorrenciaFormCubit({
    required CreateOcorrenciaUseCase createUseCase,
    required Telemetry telemetry,
    AudioRecorder? recorder,
    ImagePicker? imagePicker,
    Uuid? uuid,
  }) : _createUseCase = createUseCase,
       _telemetry = telemetry,
       _recorder = recorder ?? AudioRecorder(),
       _imagePicker = imagePicker ?? ImagePicker(),
       _uuid = uuid ?? const Uuid(),
       super(const OcorrenciaFormIdle());

  final CreateOcorrenciaUseCase _createUseCase;
  final Telemetry _telemetry;
  final AudioRecorder _recorder;
  final ImagePicker _imagePicker;
  final Uuid _uuid;

  // ---------------------------------------------------------------------------
  // Leitura do estado atual (helper)
  // ---------------------------------------------------------------------------

  OcorrenciaFormData get _currentData {
    final s = state;
    return switch (s) {
      OcorrenciaFormIdle(:final formData) => formData,
      OcorrenciaFormRecordingAudio(:final formData) => formData,
      OcorrenciaFormAttachingMedia(:final formData) => formData,
      OcorrenciaFormLocating(:final formData) => formData,
      OcorrenciaFormSaving(:final formData) => formData,
      OcorrenciaFormValidationError(:final formData) => formData,
      OcorrenciaFormError(:final formData) => formData,
      OcorrenciaFormSavedOffline() => const OcorrenciaFormData(),
    };
  }

  // ---------------------------------------------------------------------------
  // Mutação de campos simples
  // ---------------------------------------------------------------------------

  void onDescriptionChanged(String value) {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(description: value),
    ));
  }

  void onSearchQueryChanged(String value) {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(searchQuery: value),
    ));
  }

  void onLocationSelected(LatLng location) {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(selectedLocation: location),
    ));
  }

  void onDateSelected(DateTime date) {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(date: date),
    ));
  }

  void onTimeSelected(String time) {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(time: time),
    ));
  }

  void onAcknowledgesPoliceReportChanged(bool value) {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(acknowledgesPoliceReport: value),
    ));
  }

  void onAcceptsPrivacyChanged(bool value) {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(acceptsPrivacy: value),
    ));
  }

  void removeAudio() {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(audioPath: null),
    ));
  }

  void removeDocument() {
    emit(OcorrenciaFormIdle(
      formData: _currentData.copyWith(documentPath: null),
    ));
  }

  // ---------------------------------------------------------------------------
  // Localização atual
  // ---------------------------------------------------------------------------

  Future<void> useCurrentLocation() async {
    final data = _currentData;
    emit(OcorrenciaFormLocating(formData: data));
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final position = await Geolocator.getCurrentPosition();
      emit(OcorrenciaFormIdle(
        formData: data.copyWith(
          selectedLocation: LatLng(position.latitude, position.longitude),
        ),
      ));
    } catch (e) {
      debugPrint('[OcorrenciaFormCubit] Erro de localização: $e');
      emit(OcorrenciaFormIdle(formData: data));
    }
  }

  // ---------------------------------------------------------------------------
  // Gravação de áudio
  // ---------------------------------------------------------------------------

  Future<void> toggleRecording() async {
    final data = _currentData;

    if (data.isRecording) {
      // Parar gravação
      final path = await _recorder.stop();
      emit(OcorrenciaFormIdle(
        formData: data.copyWith(
          isRecording: false,
          audioPath: path,
        ),
      ));
      _telemetry.log('form.audio_recorded');
    } else {
      // Iniciar gravação
      try {
        final tmpDir = await getTemporaryDirectory();
        final audioPath = p.join(
          tmpDir.path,
          'audio_${_uuid.v4()}.m4a',
        );
        await _recorder.start(const RecordConfig(), path: audioPath);
        emit(OcorrenciaFormRecordingAudio(
          formData: data.copyWith(isRecording: true, audioPath: null),
        ));
        _telemetry.log('form.audio_started');
      } catch (e) {
        debugPrint('[OcorrenciaFormCubit] Erro ao iniciar gravação: $e');
        emit(OcorrenciaFormError(
          formData: data,
          message: 'Não foi possível iniciar a gravação.',
        ));
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Mídia e documentos
  // ---------------------------------------------------------------------------

  Future<void> pickImages() async {
    final data = _currentData;
    emit(OcorrenciaFormAttachingMedia(formData: data));
    try {
      final picked = await _imagePicker.pickMultiImage(imageQuality: 85);
      emit(OcorrenciaFormIdle(
        formData: data.copyWith(media: [...data.media, ...picked]),
      ));
      _telemetry.log('form.media_added', params: {'count': picked.length});
    } catch (e) {
      emit(OcorrenciaFormIdle(formData: data));
    }
  }

  Future<void> pickDocument() async {
    final data = _currentData;
    emit(OcorrenciaFormAttachingMedia(formData: data));
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      final path = result?.files.single.path;
      if (path != null) {
        final fileSize = await File(path).length();
        const maxBytes = 5 * 1024 * 1024;
        if (fileSize > maxBytes) {
          emit(OcorrenciaFormValidationError(
            formData: data,
            message: 'O documento deve ter menos de 5 MB.',
          ));
          return;
        }
      }
      emit(OcorrenciaFormIdle(
        formData: data.copyWith(documentPath: path),
      ));
    } catch (e) {
      emit(OcorrenciaFormIdle(formData: data));
    }
  }

  void removeMedia(int index) {
    final data = _currentData;
    final updated = List<XFile>.from(data.media)..removeAt(index);
    emit(OcorrenciaFormIdle(formData: data.copyWith(media: updated)));
  }

  // ---------------------------------------------------------------------------
  // Submit
  // ---------------------------------------------------------------------------

  Future<void> submit() async {
    final data = _currentData;

    // Validação
    if (!data.canSubmit) {
      emit(OcorrenciaFormValidationError(
        formData: data,
        message: 'Preencha todos os campos obrigatórios.',
      ));
      return;
    }

    emit(OcorrenciaFormSaving(formData: data));
    _telemetry.log('form.submit_started');

    try {
      final location = data.selectedLocation!;

      OcorrenciaAttachment? audioAttachment;
      if (data.audioPath != null) {
        audioAttachment = OcorrenciaAttachment(
          path: data.audioPath!,
          storageName: 'audio_${_uuid.v4()}.m4a',
          kind: 'audio',
        );
      }

      OcorrenciaAttachment? docAttachment;
      if (data.documentPath != null) {
        docAttachment = OcorrenciaAttachment(
          path: data.documentPath!,
          storageName: 'boletim_${_uuid.v4()}.pdf',
          kind: 'documento',
        );
      }

      final mediaAttachments = data.media.map((f) {
        final ext = p.extension(f.path).replaceAll('.', '');
        return OcorrenciaAttachment(
          path: f.path,
          storageName: 'media_${_uuid.v4()}.$ext',
          kind: ext.isEmpty ? 'imagem' : ext,
        );
      }).toList();

      final input = CreateOcorrenciaInput(
        informacoes: data.description.trim(),
        quando: data.date!,
        horario: data.time!,
        latitude: location.latitude,
        longitude: location.longitude,
        enderecoBusca: data.searchQuery.trim(),
        cienteBoletim: data.acknowledgesPoliceReport,
        aceitePrivacidade: data.acceptsPrivacy,
        audio: audioAttachment,
        boletimOcorrencia: docAttachment,
        multimidia: mediaAttachments,
      );

      final result = await _createUseCase(CreateOcorrenciaParams(input: input));

      result.fold(
        (failure) {
          emit(OcorrenciaFormError(
            formData: data,
            message: failure.message,
          ));
          _telemetry.log('form.submit_failed');
        },
        (clientId) {
          emit(OcorrenciaFormSavedOffline(clientId: clientId));
          _telemetry.log('form.submit_success', params: {
            'clientId': clientId.length > 8 ? clientId.substring(0, 8) : clientId,
          });
        },
      );
    } catch (e, st) {
      debugPrint('[OcorrenciaFormCubit] Erro inesperado: $e');
      _telemetry.recordError(e, st, reason: 'form_submit');
      emit(OcorrenciaFormError(
        formData: data,
        message: 'Ocorreu um erro inesperado. Tente novamente.',
      ));
    }
  }

  @override
  Future<void> close() async {
    await _recorder.dispose();
    return super.close();
  }
}
