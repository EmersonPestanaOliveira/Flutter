import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/errors/failure_x.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/services/ocorrencia_service.dart';
import '../../domain/usecases/create_ocorrencia_usecase.dart';

class OcorrenciaFormScreen extends StatefulWidget {
  const OcorrenciaFormScreen({super.key});

  @override
  State<OcorrenciaFormScreen> createState() => _OcorrenciaFormScreenState();
}

class _OcorrenciaFormScreenState extends State<OcorrenciaFormScreen> {
  static const _initialLocation = LatLng(-23.561684, -46.655981);
  static const _maxDescriptionLength = 1000;
  static const _maxPdfBytes = 5 * 1024 * 1024;
  static const _maxMediaBytes = 60 * 1024 * 1024;

  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  final _recorder = AudioRecorder();
  final _imagePicker = ImagePicker();
  final _createUseCase = sl<CreateOcorrenciaUseCase>();

  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  DateTime? _date;
  TimeOfDay? _time;
  PlatformFile? _document;
  String? _audioPath;
  bool _isRecording = false;
  bool _isSearching = false;
  bool _isSubmitting = false;
  bool _acknowledgesPoliceReport = false;
  bool _acceptsPrivacy = false;
  final List<XFile> _media = [];

  bool get _canSubmit {
    final hasStory =
        _descriptionController.text.trim().isNotEmpty || _audioPath != null;
    return !_isSubmitting &&
        _selectedLocation != null &&
        _date != null &&
        _time != null &&
        hasStory &&
        _acknowledgesPoliceReport &&
        _acceptsPrivacy;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _searchController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      appBar: AppBar(
        backgroundColor: AppColors.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.brandGreen,
            size: 36,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Relato de Ocorrência',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.headerBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: AppColors.brandGreen,
              size: 34,
            ),
            onPressed: () => context.push(AppRoutes.ocorrenciasInfo),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30, 28, 30, 30),
          children: [
            _SearchField(
              controller: _searchController,
              isSearching: _isSearching,
              onSubmitted: _searchLocation,
            ),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 290,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: _initialLocation,
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: (position) {
                    setState(() => _selectedLocation = position);
                  },
                  markers: {
                    if (_selectedLocation != null)
                      Marker(
                        markerId: const MarkerId('ocorrencia'),
                        position: _selectedLocation!,
                      ),
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _OutlineActionButton(
              icon: Icons.my_location,
              label: 'Usar minha localização atual',
              onTap: _useCurrentLocation,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel('Quando?'),
            _PickerField(
              hint: 'dd/mm/aaaa',
              value: _date == null
                  ? null
                  : '${_date!.day.toString().padLeft(2, '0')}/${_date!.month.toString().padLeft(2, '0')}/${_date!.year}',
              onTap: _pickDate,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel('Horário aproximado:'),
            _PickerField(
              hint: 'HH:MM',
              value: _time?.format(context),
              onTap: _pickTime,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel('Conte o que aconteceu:'),
            _AudioButton(
              isRecording: _isRecording,
              hasAudio: _audioPath != null,
              onTap: _toggleRecording,
              onDelete: _audioPath == null
                  ? null
                  : () => setState(() => _audioPath = null),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: Text(
                '* Só é possível enviar um áudio por relato.',
                style: TextStyle(
                  color: AppColors.headerBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextField(
              controller: _descriptionController,
              maxLength: _maxDescriptionLength,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText:
                    'Dê o máximo de detalhes que se lembrar. "Tinha algum veículo envolvido? Qual era?", "Como eram as pessoas? Tinha algum detalhe marcante?", "Onde exatamente aconteceu? Tem alguma referência próxima?"',
                hintStyle: const TextStyle(color: AppColors.neutral300),
                filled: true,
                fillColor: const Color(0xFFF1F3F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.neutral300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.neutral300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.brandGreen),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _OutlineActionButton(
              icon: Icons.attach_file,
              label: _document == null
                  ? 'Adicione o Boletim de Ocorrência'
                  : _document!.name,
              onTap: _pickDocument,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '* Formato aceito: PDF. Tamanho máximo: 5MB',
              style: TextStyle(color: AppColors.neutral900, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.lg),
            _MediaPickerBox(count: _media.length, onTap: _showMediaOptions),
            if (_media.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final file in _media)
                    Chip(
                      label: Text(_fileName(file.path)),
                      onDeleted: () => setState(() => _media.remove(file)),
                    ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '* Formatos aceitos: JPG, JPEG, PNG, HEIC, HEIF, WEBP, MP4 e MOV. O tamanho total não pode ultrapassar 60 MB.',
              style: TextStyle(color: AppColors.neutral900, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.xl),
            _ConsentCheckbox(
              value: _acknowledgesPoliceReport,
              onChanged: (value) =>
                  setState(() => _acknowledgesPoliceReport = value),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: AppColors.headerBlue,
                    fontSize: 18,
                    height: 1.25,
                  ),
                  children: [
                    TextSpan(text: 'Declaro ter ciência que este relato '),
                    TextSpan(
                      text: 'não substitui',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: ' o registro da ocorrência junto à polícia.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ConsentCheckbox(
              value: _acceptsPrivacy,
              onChanged: (value) => setState(() => _acceptsPrivacy = value),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: AppColors.headerBlue,
                    fontSize: 18,
                    height: 1.25,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Estou de acordo com que a Gabriel processe estes dados de acordo com sua ',
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: _openPrivacyPolicy,
                        child: const Text(
                          'Política de Privacidade.',
                          style: TextStyle(
                            color: AppColors.brandGreen,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 44),
            SizedBox(
              height: 62,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _canSubmit
                      ? AppColors.brandGreen
                      : AppColors.neutral300,
                  disabledBackgroundColor: AppColors.neutral300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _canSubmit ? _submit : null,
                child: _isSubmitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.neutral0,
                        ),
                      )
                    : const Text(
                        'Avançar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchLocation(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }

    setState(() => _isSearching = true);
    try {
      final coordinates = _parseCoordinates(trimmed);
      final location = coordinates ?? await _searchAddress(trimmed);
      if (location == null) {
        _showMessage('Não encontramos esse endereço.');
        return;
      }

      setState(() => _selectedLocation = location);
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16),
      );
    } catch (_) {
      _showMessage('Não foi possível buscar a localização.');
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  LatLng? _parseCoordinates(String value) {
    final parts = value.split(',');
    if (parts.length != 2) {
      return null;
    }

    final latitude = double.tryParse(parts[0].trim());
    final longitude = double.tryParse(parts[1].trim());
    if (latitude == null || longitude == null) {
      return null;
    }

    return LatLng(latitude, longitude);
  }

  Future<LatLng?> _searchAddress(String query) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'json',
      'limit': '1',
    });
    final client = HttpClient();
    final request = await client.getUrl(uri);
    request.headers.set('User-Agent', 'gabriel-clone-ocorrencias');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    client.close();

    final results = jsonDecode(body) as List<dynamic>;
    if (results.isEmpty) {
      return null;
    }

    final first = results.first as Map<String, dynamic>;
    return LatLng(
      double.parse(first['lat'] as String),
      double.parse(first['lon'] as String),
    );
  }

  Future<void> _useCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Ative a localização do dispositivo.');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage('Permissão de localização negada.');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    final location = LatLng(position.latitude, position.longitude);
    setState(() => _selectedLocation = location);
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 16),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
      });
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      _showMessage('Permissão de microfone negada.');
      return;
    }

    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/ocorrencia_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );
    setState(() => _isRecording = true);
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    final file = result?.files.single;
    if (file == null) {
      return;
    }

    if (file.size > _maxPdfBytes) {
      _showMessage('O PDF deve ter no máximo 5 MB.');
      return;
    }

    setState(() => _document = file);
  }

  Future<void> _showMediaOptions() async {
    if (_media.length >= 3) {
      _showMessage('Você já adicionou 3 arquivos.');
      return;
    }

    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Adicionar fotos'),
              onTap: () => Navigator.pop(context, 'photos'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Adicionar vídeo'),
              onTap: () => Navigator.pop(context, 'video'),
            ),
          ],
        ),
      ),
    );

    if (choice == 'photos') {
      final photos = await _imagePicker.pickMultiImage();
      await _addMedia(photos.take(3 - _media.length).toList());
    } else if (choice == 'video') {
      final video = await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        await _addMedia([video]);
      }
    }
  }

  Future<void> _addMedia(List<XFile> files) async {
    final newTotal = await _mediaSize(_media) + await _mediaSize(files);
    if (newTotal > _maxMediaBytes) {
      _showMessage('O total das mídias não pode ultrapassar 60 MB.');
      return;
    }

    setState(() => _media.addAll(files));
  }

  Future<int> _mediaSize(List<XFile> files) async {
    var total = 0;
    for (final file in files) {
      total += await file.length();
    }
    return total;
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse('https://gabriel.com.br/politica-de-privacidade');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _submit() async {
    final location = _selectedLocation;
    final date = _date;
    final time = _time;
    if (location == null || date == null || time == null) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await _createUseCase(
        CreateOcorrenciaParams(
          input: CreateOcorrenciaInput(
            informacoes: _descriptionController.text.trim(),
            quando: date,
            horario:
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            latitude: location.latitude,
            longitude: location.longitude,
            enderecoBusca: _searchController.text.trim(),
            cienteBoletim: _acknowledgesPoliceReport,
            aceitePrivacidade: _acceptsPrivacy,
            audio: _audioPath == null
                ? null
                : OcorrenciaAttachment(
                    path: _audioPath!,
                    storageName: _fileName(_audioPath!),
                    kind: 'audio',
                  ),
            boletimOcorrencia: _document?.path == null
                ? null
                : OcorrenciaAttachment(
                    path: _document!.path!,
                    storageName: _document!.name,
                    kind: 'documento',
                  ),
            multimidia: [
              for (final file in _media)
                OcorrenciaAttachment(
                  path: file.path,
                  storageName: _fileName(file.path),
                  kind: _isVideo(file.path) ? 'video' : 'foto',
                ),
            ],
          ),
        ),
      );

      result.fold(
        (failure) => _showMessage(failure.message),
        (_) {
          if (mounted) context.go(AppRoutes.ocorrenciasSuccess);
        },
      );
    } catch (error) {
      _showMessage(BackendErrorMapper.message(error));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  bool _isVideo(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.mp4') || lower.endsWith('.mov');
  }

  String _fileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    return normalized.split('/').last;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.isSearching,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool isSearching;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: 'Avenida Paulista, 10',
        prefixIcon: const Icon(Icons.search, color: AppColors.neutral300),
        suffixIcon: isSearching
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.brandGreen,
                ),
                onPressed: () => onSubmitted(controller.text),
              ),
        filled: true,
        fillColor: const Color(0xFFF1F3F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.neutral300),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.headerBlue,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.hint,
    required this.value,
    required this.onTap,
  });

  final String hint;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF1F3F6),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.neutral300),
          ),
        ),
        child: Text(
          value ?? hint,
          style: TextStyle(
            color: value == null ? AppColors.neutral300 : AppColors.headerBlue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.brandGreen, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.brandGreen),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.headerBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioButton extends StatelessWidget {
  const _AudioButton({
    required this.isRecording,
    required this.hasAudio,
    required this.onTap,
    required this.onDelete,
  });

  final bool isRecording;
  final bool hasAudio;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2F2),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: Text(
                  isRecording
                      ? 'Gravando... toque para parar'
                      : hasAudio
                      ? 'Áudio anexado ao relato'
                      : 'Grave um áudio relatando o que aconteceu',
                  style: const TextStyle(
                    color: AppColors.headerBlue,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.accentRed,
              ),
              onPressed: onDelete,
            ),
          IconButton(
            icon: Icon(
              isRecording ? Icons.stop_circle_outlined : Icons.mic_none,
              color: AppColors.brandGreen,
              size: 30,
            ),
            onPressed: onTap,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _MediaPickerBox extends StatelessWidget {
  const _MediaPickerBox({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.neutral900,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.headerBlue,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                count == 0
                    ? 'Adicione até 3 fotos ou vídeos que possam auxiliar no caso'
                    : '$count de 3 mídias adicionadas',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.headerBlue,
                  fontSize: 18,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  const _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: Checkbox(
              value: value,
              onChanged: (value) => onChanged(value ?? false),
              activeColor: AppColors.brandGreen,
              side: const BorderSide(color: AppColors.brandGreen, width: 2),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}
