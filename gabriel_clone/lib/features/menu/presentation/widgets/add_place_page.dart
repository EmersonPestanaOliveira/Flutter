part of '../menu_pages.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  static const _profileOptions = ['Sindico', 'Condominio', 'Administrador'];
  static const _demoPlaceId = 'demo_times_square_public';
  static const _demoCamera = {
    'id': 'public_earthcam_times_square',
    'nome': 'Times Square - camera publica',
    'provider': 'EarthCam',
    'streamUrl': 'https://www.earthcam.com/usa/newyork/timessquare/',
    'source': 'https://www.earthcam.com/usa/newyork/timessquare/',
  };

  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _numberController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _imagePicker = ImagePicker();

  DocumentSnapshot<Map<String, dynamic>>? _place;
  String? _selectedProfile;
  bool _isFaceValidated = false;
  bool _isBusy = false;

  @override
  void dispose() {
    _cepController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Localidade')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                menuFieldLabel('CEP'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CepInputFormatter()],
                  decoration: menuInputDecoration(hintText: '00000-000'),
                  validator: (v) =>
                      (v == null || v.replaceAll(RegExp(r'\D'), '').length < 8)
                      ? 'CEP inválido'
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                menuFieldLabel('Número'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: menuInputDecoration(hintText: '479'),
                  validator: _requiredText,
                ),
                if (_place != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  MatchedPlaceCard(place: _place!.data() ?? const {}),
                  const SizedBox(height: AppSpacing.xl),
                  const AddPlaceStepHeader(
                    title: 'Perfil',
                    subtitle: 'Valide qual perfil sera vinculado.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final profile in _profileOptions)
                        ChoiceChip(
                          label: Text(profile),
                          selected: _selectedProfile == profile,
                          onSelected: _isBusy
                              ? null
                              : (_) =>
                                    setState(() => _selectedProfile = profile),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const AddPlaceStepHeader(
                    title: 'Biometria facial',
                    subtitle: 'Tire uma selfie para validar seu vinculo.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: _isBusy ? null : _validateFace,
                    icon: Icon(
                      _isFaceValidated
                          ? Icons.verified_user_outlined
                          : Icons.face_retouching_natural_outlined,
                    ),
                    label: Text(
                      _isFaceValidated
                          ? 'Face validada'
                          : 'Validar biometria facial',
                    ),
                  ),
                ],
                const Spacer(),
                SizedBox(
                  height: 56,
                  child: AppButton(
                    label: _place == null ? 'Próximo' : 'Atrelar ao perfil',
                    isLoading: _isBusy,
                    onPressed: _isBusy
                        ? null
                        : (_place == null ? _findPlace : _finishLink),
                    backgroundColor: AppColors.success,
                    borderRadius: 16,
                    textStyle: const TextStyle(
                      color: AppColors.neutral0,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
