import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../home/domain/enums/alerta_tipo.dart';

/// Estados selados do formulário de ocorrência.
///
/// Cada estado captura o ciclo de vida completo:
/// idle → validating → savingLocally → savedOffline / syncFailed
///                                   → recordingAudio
///                                   → attachingMedia
///
/// Widgets devem responder a esses estados sem qualquer lógica extra.
sealed class OcorrenciaFormState extends Equatable {
  const OcorrenciaFormState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial: formulário vazio, aguardando input.
final class OcorrenciaFormIdle extends OcorrenciaFormState {
  const OcorrenciaFormIdle({this.formData = const OcorrenciaFormData()});

  final OcorrenciaFormData formData;

  @override
  List<Object?> get props => [formData];
}

/// Gravando áudio.
final class OcorrenciaFormRecordingAudio extends OcorrenciaFormState {
  const OcorrenciaFormRecordingAudio({required this.formData});

  final OcorrenciaFormData formData;

  @override
  List<Object?> get props => [formData];
}

/// Processando attach de mídia ou documento.
final class OcorrenciaFormAttachingMedia extends OcorrenciaFormState {
  const OcorrenciaFormAttachingMedia({required this.formData});

  final OcorrenciaFormData formData;

  @override
  List<Object?> get props => [formData];
}

/// Buscando localização atual.
final class OcorrenciaFormLocating extends OcorrenciaFormState {
  const OcorrenciaFormLocating({required this.formData});

  final OcorrenciaFormData formData;

  @override
  List<Object?> get props => [formData];
}

/// Validando e gravando localmente (SQLite).
final class OcorrenciaFormSaving extends OcorrenciaFormState {
  const OcorrenciaFormSaving({required this.formData});

  final OcorrenciaFormData formData;

  @override
  List<Object?> get props => [formData];
}

/// Salvo offline com sucesso (exibe feedback ao usuário).
final class OcorrenciaFormSavedOffline extends OcorrenciaFormState {
  const OcorrenciaFormSavedOffline({required this.clientId});

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

/// Erro de validação do formulário (campo inválido ou ausente).
final class OcorrenciaFormValidationError extends OcorrenciaFormState {
  const OcorrenciaFormValidationError({
    required this.formData,
    required this.message,
  });

  final OcorrenciaFormData formData;
  final String message;

  @override
  List<Object?> get props => [formData, message];
}

/// Erro inesperado ao salvar ou preparar o envio.
final class OcorrenciaFormError extends OcorrenciaFormState {
  const OcorrenciaFormError({
    required this.formData,
    required this.message,
  });

  final OcorrenciaFormData formData;
  final String message;

  @override
  List<Object?> get props => [formData, message];
}

// ---------------------------------------------------------------------------
// Value object imutável com os dados do formulário
// ---------------------------------------------------------------------------

class OcorrenciaFormData extends Equatable {
  const OcorrenciaFormData({
    this.description = '',
    this.searchQuery = '',
    this.selectedLocation,
    this.date,
    this.time,
    this.categoria,
    this.documentPath,
    this.audioPath,
    this.isRecording = false,
    this.acknowledgesPoliceReport = false,
    this.acceptsPrivacy = false,
    this.media = const [],
  });

  final String description;
  final String searchQuery;
  final LatLng? selectedLocation;
  final DateTime? date;
  final String? time;

  /// Categoria da ocorrência — obrigatória para habilitar o envio.
  final AlertaTipo? categoria;

  final String? documentPath;
  final String? audioPath;
  final bool isRecording;
  final bool acknowledgesPoliceReport;
  final bool acceptsPrivacy;
  final List<XFile> media;

  bool get canSubmit {
    return selectedLocation != null &&
        date != null &&
        time != null &&
        categoria != null &&
        (description.trim().isNotEmpty || audioPath != null) &&
        acknowledgesPoliceReport &&
        acceptsPrivacy;
  }

  OcorrenciaFormData copyWith({
    String? description,
    String? searchQuery,
    LatLng? selectedLocation,
    Object? date = _sentinel,
    Object? time = _sentinel,
    Object? categoria = _sentinel,
    Object? documentPath = _sentinel,
    Object? audioPath = _sentinel,
    bool? isRecording,
    bool? acknowledgesPoliceReport,
    bool? acceptsPrivacy,
    List<XFile>? media,
  }) {
    return OcorrenciaFormData(
      description: description ?? this.description,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      date: date == _sentinel ? this.date : date as DateTime?,
      time: time == _sentinel ? this.time : time as String?,
      categoria:
          categoria == _sentinel ? this.categoria : categoria as AlertaTipo?,
      documentPath:
          documentPath == _sentinel ? this.documentPath : documentPath as String?,
      audioPath: audioPath == _sentinel ? this.audioPath : audioPath as String?,
      isRecording: isRecording ?? this.isRecording,
      acknowledgesPoliceReport:
          acknowledgesPoliceReport ?? this.acknowledgesPoliceReport,
      acceptsPrivacy: acceptsPrivacy ?? this.acceptsPrivacy,
      media: media ?? this.media,
    );
  }

  @override
  List<Object?> get props => [
        description,
        searchQuery,
        selectedLocation,
        date,
        time,
        categoria,
        documentPath,
        audioPath,
        isRecording,
        acknowledgesPoliceReport,
        acceptsPrivacy,
        media,
      ];
}

const _sentinel = Object();
