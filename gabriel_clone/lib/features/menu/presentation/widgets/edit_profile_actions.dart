part of '../menu_pages.dart';

extension _EditProfileActions on _EditProfilePageState {
  Future<void> _loadProfile() async {
    try {
      final user = _authService.currentUser;
      final profile = await _authService.loadUserProfile();
      if (!mounted) {
        return;
      }

      _nameController.text =
          profile['name'] as String? ?? user?.displayName ?? '';
      _birthDateController.text = profile['birthDate'] as String? ?? '';
      _emailController.text = profile['email'] as String? ?? user?.email ?? '';
      _cpfController.text = profile['cpf'] as String? ?? '';
      _phoneController.text = profile['phone'] as String? ?? '';
      _photoUrl =
          profile['photoUrl'] as String? ?? _authService.cachedProfilePhotoUrl;
      final gender = profile['gender'] as String?;
      _gender = _EditProfilePageState._genderOptions.contains(gender)
          ? gender!
          : _EditProfilePageState._genderOptions.first;
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppErrorNotifier.show(context, error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _authService.updateUserProfile(
        name: _nameController.text,
        birthDate: _birthDateController.text,
        gender: _gender,
        phone: _phoneController.text,
        cpf: _cpfController.text,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil atualizado.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppErrorNotifier.show(context, error);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
