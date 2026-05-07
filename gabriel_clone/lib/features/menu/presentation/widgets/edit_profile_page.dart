part of '../menu_pages.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const _genderOptions = [
    'Não Informado',
    'Feminino',
    'Masculino',
    'Outro',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authService = sl<AuthService>();
  final _imagePicker = ImagePicker();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  String _gender = _genderOptions.first;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.md,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _EditProfileHeader(isBusy: _isSaving),
                          const SizedBox(height: AppSpacing.xl),
                          _AvatarPicker(
                            photoUrl: _photoUrl,
                            isBusy: _isUploadingPhoto,
                            onTap: _isSaving || _isUploadingPhoto
                                ? null
                                : _showPhotoSourceSheet,
                          ),
                          const SizedBox(height: 48),
                          _ProfileTextField(
                            controller: _nameController,
                            label: 'Nome Completo',
                            validator: _requiredText,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _ProfileTextField(
                            controller: _birthDateController,
                            label: 'Data de Nascimento',
                            hintText: 'dd/mm/aaaa',
                            keyboardType: TextInputType.datetime,
                            validator: _requiredText,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _GenderField(
                            value: _gender,
                            options: _genderOptions,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() => _gender = value);
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _ProfileTextField(
                            controller: _emailController,
                            label: 'Email',
                            enabled: false,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _ProfileTextField(
                            controller: _cpfController,
                            label: 'CPF',
                            enabled: false,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _ProfileTextField(
                            controller: _phoneController,
                            label: 'Telefone',
                            hintText: '+55 (11) 99999-9999',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 56),
                          FilledButton(
                            onPressed: _isSaving ? null : _saveProfile,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              backgroundColor: const Color(0xFF00C982),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.neutral0,
                                    ),
                                  )
                                : const Text(
                                    'Atualizar',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          TextButton(
                            onPressed: _isSaving ? null : _confirmDelete,
                            child: const Text(
                              'Excluir minha conta',
                              style: TextStyle(
                                color: AppColors.accentRed,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
