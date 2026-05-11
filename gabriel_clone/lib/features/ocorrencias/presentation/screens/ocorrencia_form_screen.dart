import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/geo/address_search.dart';
import '../../../../core/geo/app_map_bounds.dart';
import '../../../../core/router/app_routes.dart';
import '../../../home/domain/enums/alerta_tipo.dart';
import '../cubit/ocorrencia_form_cubit.dart';
import '../cubit/ocorrencia_form_state.dart';

class OcorrenciaFormScreen extends StatefulWidget {
  const OcorrenciaFormScreen({super.key});

  @override
  State<OcorrenciaFormScreen> createState() => _OcorrenciaFormScreenState();
}

class _OcorrenciaFormScreenState extends State<OcorrenciaFormScreen> {
  static const _initialLocation = LatLng(-23.561684, -46.655981);
  static const _maxDescriptionLength = 1000;

  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  final _cubit = sl<OcorrenciaFormCubit>();

  GoogleMapController? _mapController;
  bool _isSearching = false;

  bool _canSubmit(OcorrenciaFormState state, OcorrenciaFormData data) =>
      state is! OcorrenciaFormSaving && data.canSubmit;

  OcorrenciaFormData _formDataFrom(OcorrenciaFormState state) {
    return switch (state) {
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

  @override
  void initState() {
    super.initState();
    // Listener garante que o botão reaja imediatamente a qualquer mudança no texto.
    _descriptionController.addListener(_onDescriptionChanged);
    _searchController.addListener(_onSearchQueryChanged);
  }

  void _onDescriptionChanged() =>
      _cubit.onDescriptionChanged(_descriptionController.text);

  void _onSearchQueryChanged() =>
      _cubit.onSearchQueryChanged(_searchController.text);

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _searchController.removeListener(_onSearchQueryChanged);
    _descriptionController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  /// Mostra ao usuário quais campos ainda precisam ser preenchidos.
  void _showMissingFields(OcorrenciaFormData data) {
    final missing = <String>[];
    if (data.selectedLocation == null) missing.add('• Localização no mapa');
    if (data.date == null) missing.add('• Data');
    if (data.time == null) missing.add('• Horário');
    if (data.categoria == null) missing.add('• Categoria da ocorrência');
    if (data.description.trim().isEmpty && data.audioPath == null) {
      missing.add('• Descrição ou áudio do que aconteceu');
    }
    if (!data.acknowledgesPoliceReport) missing.add('• Aceite do termo de BO');
    if (!data.acceptsPrivacy) missing.add('• Aceite da política de privacidade');
    if (missing.isEmpty) return;
    _showMessage('Preencha os campos obrigatórios:\n${missing.join('\n')}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OcorrenciaFormCubit, OcorrenciaFormState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state case OcorrenciaFormValidationError(:final message)) {
          _showMessage(message);
        } else if (state case OcorrenciaFormError(:final message)) {
          _showMessage(message);
        } else if (state is OcorrenciaFormSavedOffline) {
          context.go(AppRoutes.ocorrenciasSuccess);
        }
      },
      builder: (context, state) {
        final data = _formDataFrom(state);
        final canSubmit = _canSubmit(state, data);

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
                  cameraTargetBounds: AppMapBounds.southeastBrazilCameraTarget,
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: _cubit.onLocationSelected,
                  markers: {
                    if (data.selectedLocation != null)
                      Marker(
                        markerId: const MarkerId('ocorrencia'),
                        position: data.selectedLocation!,
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
              value: data.date == null
                  ? null
                  : '${data.date!.day.toString().padLeft(2, '0')}/${data.date!.month.toString().padLeft(2, '0')}/${data.date!.year}',
              onTap: _pickDate,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel('Horário aproximado:'),
            _PickerField(
              hint: 'HH:MM',
              value: data.time,
              onTap: _pickTime,
            ),
            const SizedBox(height: AppSpacing.lg),
            _RequiredFieldLabel('Categoria da ocorrência:'),
            DropdownButtonFormField<AlertaTipo>(
              initialValue: data.categoria,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Selecione uma categoria',
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
              items: AlertaTipo.values
                  .map(
                    (tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) _cubit.onCategoriaSelected(value);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _RequiredFieldLabel('Conte o que aconteceu:'),
            _AudioButton(
              isRecording: data.isRecording,
              hasAudio: data.audioPath != null,
              onTap: _toggleRecording,
              onDelete: data.audioPath == null
                  ? null
                  : _cubit.removeAudio,
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: Text(
                '* Áudio é opcional. Só é possível enviar um áudio por relato.',
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
              label: data.documentPath == null
                  ? 'Adicione o Boletim de Ocorrência'
                  : _fileName(data.documentPath!),
              onTap: _pickDocument,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '* Formato aceito: PDF. Tamanho máximo: 5MB',
              style: TextStyle(color: AppColors.neutral900, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.lg),
            _MediaPickerBox(count: data.media.length, onTap: _showMediaOptions),
            if (data.media.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (var i = 0; i < data.media.length; i++)
                    Chip(
                      label: Text(_fileName(data.media[i].path)),
                      onDeleted: () => _cubit.removeMedia(i),
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
              value: data.acknowledgesPoliceReport,
              onChanged: (value) =>
                  _cubit.onAcknowledgesPoliceReportChanged(value),
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
              value: data.acceptsPrivacy,
              onChanged: _cubit.onAcceptsPrivacyChanged,
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
              child: GestureDetector(
                // Quando desabilitado, mostra quais campos faltam preencher.
                onTap: canSubmit ? null : () => _showMissingFields(data),
                child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: canSubmit
                      ? AppColors.brandGreen
                      : AppColors.neutral300,
                  disabledBackgroundColor: AppColors.neutral300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: canSubmit ? _submit : null,
                child: state is OcorrenciaFormSaving
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
            ),
          ],
        ),
      ),
        );
      },
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

      _cubit.onLocationSelected(location);
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
    return searchAddressCoordinates(query);
  }

  Future<void> _useCurrentLocation() async {
    await _cubit.useCurrentLocation();
    final location = _formDataFrom(_cubit.state).selectedLocation;
    if (location != null) {
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _formDataFrom(_cubit.state).date ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
    );
    if (picked != null) {
      _cubit.onDateSelected(picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _parseTimeOfDay(_formDataFrom(_cubit.state).time) ??
          TimeOfDay.now(),
    );
    if (picked != null) {
      _cubit.onTimeSelected(
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
      );
    }
  }

  TimeOfDay? _parseTimeOfDay(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _toggleRecording() async {
    await _cubit.toggleRecording();
  }

  Future<void> _pickDocument() async {
    await _cubit.pickDocument();
  }

  Future<void> _showMediaOptions() async {
    if (_formDataFrom(_cubit.state).media.length >= 3) {
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
      await _cubit.pickImages();
    } else if (choice == 'video') {
      await _cubit.pickVideo();
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse('https://gabriel.com.br/politica-de-privacidade');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _submit() async {
    await _cubit.submit();
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

class _RequiredFieldLabel extends StatelessWidget {
  const _RequiredFieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.headerBlue,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: AppColors.accentRed,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
