import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import 'package:gabriel_clone/core/errors/failures.dart';
import 'package:gabriel_clone/core/observability/telemetry.dart';
import 'package:gabriel_clone/core/types/app_result.dart';
import 'package:gabriel_clone/features/ocorrencias/data/services/ocorrencia_service.dart';
import 'package:gabriel_clone/features/ocorrencias/domain/usecases/create_ocorrencia_usecase.dart';
import 'package:gabriel_clone/features/ocorrencias/presentation/cubit/ocorrencia_form_cubit.dart';
import 'package:gabriel_clone/features/ocorrencias/presentation/cubit/ocorrencia_form_state.dart';

// ---------------------------------------------------------------------------
// Fakes / Mocks
// ---------------------------------------------------------------------------

class _FakeCreateUseCase extends Fake implements CreateOcorrenciaUseCase {
  AppResult<String> result = const Right('client-abc');

  @override
  Future<AppResult<String>> call(CreateOcorrenciaParams params) async => result;
}

class _FakeTelemetry extends Telemetry {
  const _FakeTelemetry();

  @override
  Future<T> trace<T>(
    String name,
    Future<T> Function() body, {
    Map<String, String> attributes = const {},
    Map<String, int> metrics = const {},
  }) => body();

  @override
  void log(String event, {Map<String, Object?> params = const {}}) {}

  @override
  void recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) {}
}

/// Stub de AudioRecorder que não acessa nada de plataforma.
class _FakeRecorder extends Fake implements AudioRecorder {
  bool _recording = false;
  String? _startedPath;

  @override
  Future<void> start(RecordConfig config, {required String path}) async {
    _recording = true;
    _startedPath = path;
  }

  @override
  Future<String?> stop() async {
    _recording = false;
    return _startedPath;
  }

  @override
  Future<void> dispose() async {}
}

/// Stub de ImagePicker que devolve lista fixa.
class _FakeImagePicker extends Fake implements ImagePicker {
  List<XFile> filesToReturn = [];

  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
    int? limit,
  }) async => filesToReturn;
}

/// Uuid determinístico para testes.
class _SeqUuid extends Fake implements Uuid {
  int _counter = 0;

  @override
  String v4({V4Options? config, Map<String, dynamic>? options}) =>
      'test-uuid-${_counter++}';
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

OcorrenciaFormCubit _makeCubit({
  _FakeCreateUseCase? useCase,
  _FakeRecorder? recorder,
  _FakeImagePicker? imagePicker,
}) {
  return OcorrenciaFormCubit(
    createUseCase: useCase ?? _FakeCreateUseCase(),
    telemetry: const _FakeTelemetry(),
    recorder: recorder ?? _FakeRecorder(),
    imagePicker: imagePicker ?? _FakeImagePicker(),
    uuid: _SeqUuid(),
  );
}

/// Retorna um [OcorrenciaFormData] completamente preenchido que passa em
/// [canSubmit].
OcorrenciaFormData _validData() => const OcorrenciaFormData(
  description: 'Descrição da ocorrência',
  selectedLocation: LatLng(-23.5, -46.6),
  date: null, // será sobrescrito via cubit
  time: '10:00',
  acknowledgesPoliceReport: true,
  acceptsPrivacy: true,
).copyWith(date: DateTime(2026, 5, 6));

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('OcorrenciaFormData.canSubmit', () {
    test('false quando description e audioPath ambos vazios', () {
      const data = OcorrenciaFormData(
        selectedLocation: LatLng(-23.0, -46.0),
        time: '10:00',
        acknowledgesPoliceReport: true,
        acceptsPrivacy: true,
      );
      expect(data.copyWith(date: DateTime(2026)).canSubmit, isFalse);
    });

    test('true com description preenchida e todos campos obrigatórios', () {
      expect(_validData().canSubmit, isTrue);
    });

    test('true quando description vazia mas audioPath preenchido', () {
      final data = _validData().copyWith(
        description: '',
        audioPath: '/tmp/audio.m4a',
      );
      expect(data.canSubmit, isTrue);
    });

    test('false sem localização', () {
      final data = OcorrenciaFormData(
        description: 'ok',
        date: DateTime(2026),
        time: '09:00',
        acknowledgesPoliceReport: true,
        acceptsPrivacy: true,
      );
      expect(data.canSubmit, isFalse);
    });

    test('false sem aceite de privacidade', () {
      final data = _validData().copyWith(acceptsPrivacy: false);
      expect(data.canSubmit, isFalse);
    });
  });

  group('OcorrenciaFormCubit — mutação de campos', () {
    late OcorrenciaFormCubit cubit;

    setUp(() => cubit = _makeCubit());
    tearDown(() => cubit.close());

    test('onDescriptionChanged atualiza formData', () {
      cubit.onDescriptionChanged('texto de teste');
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.description, 'texto de teste');
    });

    test('onLocationSelected atualiza selectedLocation', () {
      const location = LatLng(-23.5, -46.6);
      cubit.onLocationSelected(location);
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.selectedLocation, location);
    });

    test('onDateSelected atualiza date', () {
      final date = DateTime(2026, 5, 6);
      cubit.onDateSelected(date);
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.date, date);
    });

    test('onTimeSelected atualiza time', () {
      cubit.onTimeSelected('14:30');
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.time, '14:30');
    });

    test('onAcceptsPrivacyChanged atualiza acceptsPrivacy', () {
      cubit.onAcceptsPrivacyChanged(true);
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.acceptsPrivacy, isTrue);
    });

    test('removeMedia remove item por índice', () {
      // Simula estado com 2 imagens
      cubit.onDescriptionChanged('x'); // chama _currentData internamente
      final file1 = XFile('/tmp/img1.jpg');
      final file2 = XFile('/tmp/img2.jpg');
      // Injeta estado com media diretamente via emit
      cubit.emit(
        OcorrenciaFormIdle(
          formData: const OcorrenciaFormData().copyWith(media: [file1, file2]),
        ),
      );
      cubit.removeMedia(0);
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.media, [file2]);
    });
  });

  group('OcorrenciaFormCubit — toggleRecording', () {
    late _FakeRecorder recorder;
    late OcorrenciaFormCubit cubit;

    setUp(() {
      recorder = _FakeRecorder();
      cubit = _makeCubit(recorder: recorder);
    });
    tearDown(() => cubit.close());

    test('primeiro toggle inicia gravação e emite RecordingAudio', () async {
      await cubit.toggleRecording();
      expect(cubit.state, isA<OcorrenciaFormRecordingAudio>());
      final state = cubit.state as OcorrenciaFormRecordingAudio;
      expect(state.formData.isRecording, isTrue);
    });

    test('segundo toggle para gravação e emite Idle com audioPath', () async {
      await cubit.toggleRecording(); // inicia
      await cubit.toggleRecording(); // para
      expect(cubit.state, isA<OcorrenciaFormIdle>());
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.isRecording, isFalse);
      expect(state.formData.audioPath, isNotNull);
    });
  });

  group('OcorrenciaFormCubit — pickImages', () {
    late _FakeImagePicker imagePicker;
    late OcorrenciaFormCubit cubit;

    setUp(() {
      imagePicker = _FakeImagePicker();
      cubit = _makeCubit(imagePicker: imagePicker);
    });
    tearDown(() => cubit.close());

    test('adiciona imagens selecionadas ao formData.media', () async {
      imagePicker.filesToReturn = [XFile('/tmp/a.jpg'), XFile('/tmp/b.jpg')];
      await cubit.pickImages();
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.media.length, 2);
    });

    test('não adiciona nada se lista retornada for vazia', () async {
      imagePicker.filesToReturn = [];
      await cubit.pickImages();
      final state = cubit.state as OcorrenciaFormIdle;
      expect(state.formData.media, isEmpty);
    });
  });

  group('OcorrenciaFormCubit — submit', () {
    late _FakeCreateUseCase useCase;
    late OcorrenciaFormCubit cubit;

    setUp(() {
      useCase = _FakeCreateUseCase();
      cubit = _makeCubit(useCase: useCase);
    });
    tearDown(() => cubit.close());

    test('submit com dados inválidos emite ValidationError', () async {
      // Estado default está vazio → canSubmit = false
      await cubit.submit();
      expect(cubit.state, isA<OcorrenciaFormValidationError>());
      final state = cubit.state as OcorrenciaFormValidationError;
      expect(state.message, isNotEmpty);
    });

    test(
      'submit com dados válidos emite SavedOffline em caso de sucesso',
      () async {
        useCase.result = const Right('generated-client-id');
        _seedValidState(cubit);
        await cubit.submit();
        expect(cubit.state, isA<OcorrenciaFormSavedOffline>());
        final state = cubit.state as OcorrenciaFormSavedOffline;
        expect(state.clientId, 'generated-client-id');
      },
    );

    test('submit emite estados: Saving → SavedOffline em ordem', () async {
      useCase.result = const Right('client-xyz');
      _seedValidState(cubit);

      final states = <OcorrenciaFormState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.submit();
      await sub.cancel();

      expect(states.first, isA<OcorrenciaFormSaving>());
      expect(states.last, isA<OcorrenciaFormSavedOffline>());
    });

    test(
      'submit emite OcorrenciaFormError quando use case retorna failure',
      () async {
        useCase.result = Left(const UnknownFailure());
        _seedValidState(cubit);
        await cubit.submit();
        expect(cubit.state, isA<OcorrenciaFormError>());
        final state = cubit.state as OcorrenciaFormError;
        expect(state.message, isNotEmpty);
      },
    );
  });
}

/// Injeta um estado idle com dados válidos no cubit para que submit passe na
/// validação.
void _seedValidState(OcorrenciaFormCubit cubit) {
  cubit.emit(OcorrenciaFormIdle(formData: _validData()));
}
