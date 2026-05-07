part of '../menu_pages.dart';

extension _EditProfileDeleteActions on _EditProfilePageState {
  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir minha conta'),
          content: const Text(
            'Essa ação remove seus dados e não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentRed,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _authService.deleteAccount();
      if (mounted) {
        Navigator.of(context).pop();
      }
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
