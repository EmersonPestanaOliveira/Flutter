import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../auth/data/auth_service.dart';
import '../../../auth/data/biometric_preferences.dart';
import '../../../auth/data/biometric_service.dart';
import '../../../auth/presentation/pages/unlock_page.dart';
import '../../../auth/presentation/widgets/auth_error_mapper.dart';
import '../pages/home_page.dart';

class ProfileMenuSheet extends StatefulWidget {
  const ProfileMenuSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // <- permite sheet maior que metade da tela
      builder: (_) => const ProfileMenuSheet(),
    );
  }

  @override
  State<ProfileMenuSheet> createState() => _ProfileMenuSheetState();
}

class _ProfileMenuSheetState extends State<ProfileMenuSheet> {
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _loadBiometric();
  }

  Future<void> _loadBiometric() async {
    final available = await BiometricService.instance.isAvailable();
    final user = AuthService.instance.currentUser;
    final enabled = user != null
        ? await BiometricPreferences.instance.isEnabled(user.uid)
        : false;
    if (!mounted) return;
    setState(() {
      _biometricAvailable = available;
      _biometricEnabled = enabled;
      _checking = false;
    });
  }

  Future<void> _toggleBiometric(bool newValue) async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;

    if (newValue) {
      final ok = await BiometricService.instance.authenticate(
        reason: 'Confirme para ativar a biometria',
      );
      if (!ok) return;
    }

    await BiometricPreferences.instance.setEnabled(user.uid, newValue);
    updateBiometricCache(newValue);
    if (mounted) setState(() => _biometricEnabled = newValue);
  }

  Future<void> _handleLogout() async {
    Navigator.of(context).pop();
    try {
      lockSession();
      resetBiometricPromptFlag();
      await AuthService.instance.signOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapAuthError(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final name = user?.displayName ?? 'Cliente';
    final email = user?.email ?? '';
    final photoUrl = user?.photoURL;

    // Limita o sheet a no maximo 85% da altura da tela -
    // sobra espaco pra ver a home por tras.
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle do bottom sheet.
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              // Avatar + nome + email.
              Row(
                children: [
                  _Avatar(photoUrl: photoUrl),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.brandBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: AppTypography.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),
              // Toggle de biometria (so aparece se suportado).
              if (_checking)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (_biometricAvailable)
                _BiometricToggleTile(
                  enabled: _biometricEnabled,
                  onChanged: _toggleBiometric,
                ),
              _MenuItem(
                icon: Icons.person_outline,
                label: 'Meu perfil',
                onTap: () => Navigator.of(context).pop(),
              ),
              _MenuItem(
                icon: Icons.calendar_today_outlined,
                label: 'Meus agendamentos',
                onTap: () => Navigator.of(context).pop(),
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: 'Configuracoes',
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),
              _MenuItem(
                icon: Icons.logout,
                label: 'Sair',
                color: AppColors.error,
                onTap: _handleLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BiometricToggleTile extends StatelessWidget {
  const _BiometricToggleTile({
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.fingerprint,
            color: AppColors.brandPurple,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usar biometria',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  enabled
                      ? 'Ativada para este dispositivo'
                      : 'Desbloqueie o app com digital ou face',
                  style: AppTypography.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeColor: AppColors.brandPurple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl});
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryLight,
        border: Border.all(color: AppColors.brandPink, width: 2),
      ),
      child: ClipOval(
        child: photoUrl != null
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: AppColors.textTertiary,
                  size: 32,
                ),
              )
            : const Icon(
                Icons.person,
                color: AppColors.textTertiary,
                size: 32,
              ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(icon, color: c, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  color: c,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
