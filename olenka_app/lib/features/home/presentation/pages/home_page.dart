import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../auth/data/auth_service.dart';
import '../../../auth/data/biometric_preferences.dart';
import '../../../auth/data/biometric_service.dart';
import '../../../auth/presentation/widgets/biometric_opt_in_dialog.dart';
import '../widgets/categories_carousel.dart';
import '../widgets/featured_treatments.dart';
import '../widgets/home_header.dart';
import '../widgets/home_hero.dart';
import '../widgets/testimonial_card.dart';
import '../widgets/whatsapp_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Flag global simples para evitar que o prompt de biometria
/// dispare mais de uma vez na mesma sessao do app, mesmo que
/// a HomePage seja reconstruida por mudanca de rota.
bool _biometricPromptChecked = false;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAskBiometric());
  }

  Future<void> _maybeAskBiometric() async {
    // Se ja verificamos nessa sessao do app, sai.
    if (_biometricPromptChecked) {
      debugPrint('[HomePage] prompt ja verificado nessa sessao, pulando');
      return;
    }
    _biometricPromptChecked = true;

    final user = AuthService.instance.currentUser;
    if (user == null || !mounted) return;

    debugPrint('[HomePage] checando prompt para uid=${user.uid}');

    // Se ja perguntamos, nunca mais pergunta.
    final asked = await BiometricPreferences.instance.wasAsked(user.uid);
    if (asked) {
      debugPrint('[HomePage] usuario ja foi perguntado antes. Pulando.');
      return;
    }
    if (!mounted) return;

    // Device suporta biometria?
    final available = await BiometricService.instance.isAvailable();
    debugPrint('[HomePage] biometria disponivel no device: $available');
    if (!available || !mounted) return;

    // MARCA COMO PERGUNTADO ANTES de mostrar o dialog.
    // Se o usuario fechar o app no meio, nao queremos insistir.
    await BiometricPreferences.instance.markAsAsked(user.uid);

    if (!mounted) return;
    final accepted = await BiometricOptInDialog.show(context);
    debugPrint('[HomePage] dialog retornou accepted=$accepted');
    if (!accepted) return;

    // Pede biometria pra confirmar.
    final ok = await BiometricService.instance.authenticate(
      reason: 'Confirme para ativar a biometria',
    );
    debugPrint('[HomePage] biometria confirmada: $ok');
    if (!ok) return;

    await BiometricPreferences.instance.setEnabled(user.uid, true);
    updateBiometricCache(true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometria ativada com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final fullName = user?.displayName ?? 'Cliente';
    final firstName = fullName.split(' ').first;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: HomeHeader(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: HomeHero(
                      userName: firstName,
                      onSchedulePressed: () {},
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: CategoriesCarousel(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const FeaturedTreatments(),
                  const SizedBox(height: AppSpacing.xl),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: TestimonialCard(),
                  ),
                  const SizedBox(height: AppSpacing.xxl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const WhatsappFab(),
    );
  }
}

/// Reseta a flag ao fazer logout.
/// O ProfileMenuSheet deve chamar isso antes de signOut.
void resetBiometricPromptFlag() {
  _biometricPromptChecked = false;
}
