# ============================================================
#  Olenka App - Fase 4 (Login + Biometria com prompt automatico)
#
#  Diferencas do script anterior:
#   - Prompt automatico de biometria apos primeiro login.
#   - Fallback estrito: falha/cancelamento -> logout + /login.
#   - BiometricPreferences com flag "wasAsked" para nao insistir.
# ============================================================

$ErrorActionPreference = 'Stop'

if (-not (Test-Path ".\pubspec.yaml")) {
    Write-Host "ERRO: rode na raiz do projeto." -ForegroundColor Red
    exit 1
}
if (-not (Test-Path ".\lib\features\auth\data\auth_service.dart")) {
    Write-Host "ERRO: AuthService nao encontrado." -ForegroundColor Red
    exit 1
}

Write-Host "==> Fase 4: Login + Biometria..." -ForegroundColor Cyan

function Write-File {
    param([Parameter(Mandatory)][string] $Path, [Parameter(Mandatory)][string] $Content)
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $full = Join-Path -Path (Get-Location) -ChildPath $Path
    [System.IO.File]::WriteAllText($full, $Content, $utf8NoBom)
    Write-Host "   + $Path"
}

# ============================================================
$routes = @'
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String unlock = '/unlock';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
}
'@
Write-File -Path "lib\core\constants\app_routes.dart" -Content $routes

# ============================================================
$biometricPrefs = @'
import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia da biometria por uid. Tres estados: enabled, disabled,
/// "undecided" (wasAsked=false).
class BiometricPreferences {
  BiometricPreferences._();
  static final instance = BiometricPreferences._();

  static const _enabledPrefix = 'biometric_enabled_';
  static const _askedPrefix = 'biometric_asked_';

  Future<bool> isEnabled(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_enabledPrefix$uid') ?? false;
  }

  Future<void> setEnabled(String uid, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_enabledPrefix$uid', value);
  }

  Future<bool> wasAsked(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_askedPrefix$uid') ?? false;
  }

  Future<void> markAsAsked(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_askedPrefix$uid', true);
  }

  Future<void> clear(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_enabledPrefix$uid');
    await prefs.remove('$_askedPrefix$uid');
  }
}
'@
Write-File -Path "lib\features\auth\data\biometric_preferences.dart" -Content $biometricPrefs

# ============================================================
$biometricService = @'
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  BiometricService._();
  static final instance = BiometricService._();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;
      final biometrics = await _auth.getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> authenticate({
    String reason = 'Desbloqueie para acessar sua conta',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
'@
Write-File -Path "lib\features\auth\data\biometric_service.dart" -Content $biometricService

# ============================================================
$googleIcon = @'
import 'package:flutter/material.dart';

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({this.size = 24, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 48;
    final blue = Paint()..color = const Color(0xFF4285F4);
    final green = Paint()..color = const Color(0xFF34A853);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final red = Paint()..color = const Color(0xFFEA4335);

    final pathBlue = Path()
      ..moveTo(46.9 * scale, 24.5 * scale)
      ..cubicTo(46.9 * scale, 22.8 * scale, 46.7 * scale, 21.2 * scale,
          46.5 * scale, 19.7 * scale)
      ..lineTo(24 * scale, 19.7 * scale)
      ..lineTo(24 * scale, 28.8 * scale)
      ..lineTo(36.9 * scale, 28.8 * scale)
      ..cubicTo(36.4 * scale, 31.7 * scale, 34.7 * scale, 34.2 * scale,
          32.1 * scale, 35.9 * scale)
      ..lineTo(32.1 * scale, 41.9 * scale)
      ..lineTo(39.9 * scale, 41.9 * scale)
      ..cubicTo(44.5 * scale, 37.7 * scale, 46.9 * scale, 31.6 * scale,
          46.9 * scale, 24.5 * scale)
      ..close();
    canvas.drawPath(pathBlue, blue);

    final pathGreen = Path()
      ..moveTo(24 * scale, 48 * scale)
      ..cubicTo(30.5 * scale, 48 * scale, 35.9 * scale, 45.9 * scale,
          39.9 * scale, 41.9 * scale)
      ..lineTo(32.1 * scale, 35.9 * scale)
      ..cubicTo(29.9 * scale, 37.4 * scale, 27.2 * scale, 38.3 * scale,
          24 * scale, 38.3 * scale)
      ..cubicTo(17.7 * scale, 38.3 * scale, 12.4 * scale, 34 * scale,
          10.5 * scale, 28.3 * scale)
      ..lineTo(2.5 * scale, 28.3 * scale)
      ..lineTo(2.5 * scale, 34.4 * scale)
      ..cubicTo(6.5 * scale, 42.3 * scale, 14.6 * scale, 48 * scale,
          24 * scale, 48 * scale)
      ..close();
    canvas.drawPath(pathGreen, green);

    final pathYellow = Path()
      ..moveTo(10.5 * scale, 28.3 * scale)
      ..cubicTo(10 * scale, 26.8 * scale, 9.7 * scale, 25.2 * scale,
          9.7 * scale, 23.5 * scale)
      ..cubicTo(9.7 * scale, 21.8 * scale, 10 * scale, 20.2 * scale,
          10.5 * scale, 18.7 * scale)
      ..lineTo(10.5 * scale, 12.6 * scale)
      ..lineTo(2.5 * scale, 12.6 * scale)
      ..cubicTo(0.9 * scale, 15.8 * scale, 0 * scale, 19.5 * scale,
          0 * scale, 23.5 * scale)
      ..cubicTo(0 * scale, 27.5 * scale, 0.9 * scale, 31.2 * scale,
          2.5 * scale, 34.4 * scale)
      ..lineTo(10.5 * scale, 28.3 * scale)
      ..close();
    canvas.drawPath(pathYellow, yellow);

    final pathRed = Path()
      ..moveTo(24 * scale, 9.5 * scale)
      ..cubicTo(27.5 * scale, 9.5 * scale, 30.7 * scale, 10.7 * scale,
          33.2 * scale, 13.1 * scale)
      ..lineTo(40 * scale, 6.3 * scale)
      ..cubicTo(35.9 * scale, 2.4 * scale, 30.5 * scale, 0 * scale,
          24 * scale, 0 * scale)
      ..cubicTo(14.6 * scale, 0 * scale, 6.5 * scale, 5.7 * scale,
          2.5 * scale, 13.6 * scale)
      ..lineTo(10.5 * scale, 19.7 * scale)
      ..cubicTo(12.4 * scale, 14 * scale, 17.7 * scale, 9.5 * scale,
          24 * scale, 9.5 * scale)
      ..close();
    canvas.drawPath(pathRed, red);
  }

  @override
  bool shouldRepaint(_) => false;
}
'@
Write-File -Path "lib\design_system\widgets\buttons\google_icon.dart" -Content $googleIcon

# ============================================================
$loginPage = @'
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/widgets/buttons/google_icon.dart';
import '../../../../design_system/widgets/buttons/gradient_button.dart';
import '../../../../design_system/widgets/inputs/app_text_field.dart';
import '../../data/auth_service.dart';
import '../widgets/auth_error_mapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      _showError(mapAuthError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _loading = true);
    try {
      await AuthService.instance.signInWithGoogle();
    } catch (e) {
      _showError(mapAuthError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    Center(
                      child: Image.asset(
                        'assets/logos/logo.webp',
                        width: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Bem-vindo(a)!',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.brandBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Acesse sua conta ou cadastre-se',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      hint: 'Seu e-mail',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe seu e-mail';
                        if (!v.contains('@')) return 'E-mail invalido';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      hint: 'Senha',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe sua senha';
                        if (v.length < 6) return 'Minimo 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GradientButton(
                      label: _loading ? 'Entrando...' : 'Entrar',
                      onPressed: _loading ? null : _handleEmailLogin,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: TextButton(
                        onPressed: _loading
                            ? null
                            : () => context.push(AppRoutes.forgotPassword),
                        child: Text(
                          'Esqueceu sua senha?',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.brandPurple,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _DividerRow(),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: _GoogleSocialButton(
                        loading: _loading,
                        onPressed: _handleGoogleLogin,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.bodyMedium,
                          children: [
                            const TextSpan(text: 'Nao possui uma conta? '),
                            TextSpan(
                              text: 'Cadastre-se',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.brandPurple,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(AppRoutes.signup);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerRow extends StatelessWidget {
  const _DividerRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.textTertiary.withValues(alpha: 0.4)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('Ou continue com', style: AppTypography.bodyMedium),
        ),
        Expanded(
          child: Divider(color: AppColors.textTertiary.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}

class _GoogleSocialButton extends StatelessWidget {
  const _GoogleSocialButton({
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandBlue.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GoogleIcon(size: 22),
                const SizedBox(width: 12),
                Text(
                  'Continuar com Google',
                  style: AppTypography.buttonLabel.copyWith(
                    color: AppColors.textPrimary,
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
'@
Write-File -Path "lib\features\auth\presentation\pages\login_page.dart" -Content $loginPage

# ============================================================
$unlockPage = @'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../data/auth_service.dart';
import '../../data/biometric_preferences.dart';
import '../../data/biometric_service.dart';

/// Fallback ESTRITO: qualquer falha/cancelamento -> logout + login.
class UnlockPage extends StatefulWidget {
  const UnlockPage({super.key});

  @override
  State<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends State<UnlockPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    final ok = await BiometricService.instance.authenticate(
      reason: 'Desbloqueie para acessar a Olenka',
    );
    if (!mounted) return;

    if (ok) {
      _unlockedSession = true;
      context.go(AppRoutes.home);
      return;
    }

    await _forceLogout();
  }

  Future<void> _forceLogout() async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid != null) {
      await BiometricPreferences.instance.clear(uid);
    }
    updateBiometricCache(false);
    lockSession();
    await AuthService.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Cliente';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/logo.webp',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandPink.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 64,
                      color: AppColors.brandPurple,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Ola, $name',
                    textAlign: TextAlign.center,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.brandBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Autenticando com biometria...',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.brandPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool _unlockedSession = false;

bool isSessionUnlocked() => _unlockedSession;
void lockSession() {
  _unlockedSession = false;
}
'@
Write-File -Path "lib\features\auth\presentation\pages\unlock_page.dart" -Content $unlockPage

# ============================================================
$biometricDialog = @'
import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/widgets/buttons/gradient_button.dart';

class BiometricOptInDialog extends StatelessWidget {
  const BiometricOptInDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const BiometricOptInDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fingerprint,
                size: 40,
                color: AppColors.brandPurple,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Usar biometria?',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Entre mais rapido no app com sua\ndigital ou reconhecimento facial.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientButton(
              label: 'Ativar biometria',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Agora nao',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@
Write-File -Path "lib\features\auth\presentation\widgets\biometric_opt_in_dialog.dart" -Content $biometricDialog

# ============================================================
$router = @'
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_routes.dart';
import '../features/auth/data/auth_service.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/unlock_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

bool _biometricEnabledCache = false;

void updateBiometricCache(bool value) {
  _biometricEnabledCache = value;
}

Future<void> warmUpBiometricCache(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  _biometricEnabledCache = prefs.getBool('biometric_enabled_$uid') ?? false;
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: GoRouterRefreshStream(
    AuthService.instance.authStateChanges,
  ),
  redirect: (context, state) {
    final loggedIn = AuthService.instance.currentUser != null;
    final location = state.matchedLocation;

    if (location == AppRoutes.splash) return null;

    const publicRoutes = {
      AppRoutes.login,
      AppRoutes.signup,
      AppRoutes.forgotPassword,
    };
    final isPublic = publicRoutes.contains(location);

    if (!loggedIn) {
      return isPublic ? null : AppRoutes.login;
    }

    if (isPublic) return AppRoutes.home;

    if (_biometricEnabledCache &&
        !isSessionUnlocked() &&
        location != AppRoutes.unlock) {
      return AppRoutes.unlock;
    }

    if (location == AppRoutes.unlock && !_biometricEnabledCache) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.unlock,
      name: 'unlock',
      builder: (context, state) => const UnlockPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
'@
Write-File -Path "lib\app\app_router.dart" -Content $router

# ============================================================
$splashPage = @'
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/widgets/loadings/dots_loader.dart';
import '../../../auth/data/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
    _boot();
  }

  Future<void> _boot() async {
    final minWait = Future<void>.delayed(const Duration(milliseconds: 2000));

    final user = AuthService.instance.currentUser;
    if (user != null) {
      await warmUpBiometricCache(user.uid);
    }

    await minWait;
    if (!mounted) return;

    final loggedIn = AuthService.instance.currentUser != null;
    context.go(loggedIn ? AppRoutes.home : AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logos/logo.webp',
                        width: 240,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: AppSpacing.xxxl * 1.5),
                      const DotsLoader(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
'@
Write-File -Path "lib\features\splash\presentation\pages\splash_page.dart" -Content $splashPage

# ============================================================
$homePage = @'
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

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAskBiometric());
  }

  Future<void> _maybeAskBiometric() async {
    final user = AuthService.instance.currentUser;
    if (user == null || !mounted) return;

    final asked = await BiometricPreferences.instance.wasAsked(user.uid);
    if (asked || !mounted) return;

    final available = await BiometricService.instance.isAvailable();
    if (!available || !mounted) return;

    await BiometricPreferences.instance.markAsAsked(user.uid);

    if (!mounted) return;
    final accepted = await BiometricOptInDialog.show(context);
    if (!accepted) return;

    final ok = await BiometricService.instance.authenticate(
      reason: 'Confirme para ativar a biometria',
    );
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
'@
Write-File -Path "lib\features\home\presentation\pages\home_page.dart" -Content $homePage

# ============================================================
$profileMenu = @'
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

class ProfileMenuSheet extends StatefulWidget {
  const ProfileMenuSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
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
    final user = AuthService.instance.currentUser;
    try {
      lockSession();
      if (user != null) {
        await BiometricPreferences.instance.clear(user.uid);
        updateBiometricCache(false);
      }
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

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
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
            const SizedBox(height: AppSpacing.sm),
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
            const SizedBox(height: AppSpacing.sm),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            _MenuItem(
              icon: Icons.logout,
              label: 'Sair',
              color: AppColors.error,
              onTap: _handleLogout,
            ),
          ],
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
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                color: c,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@
Write-File -Path "lib\features\home\presentation\widgets\profile_menu_sheet.dart" -Content $profileMenu

Write-Host ""
Write-Host "==> OK! Fase 4 concluida." -ForegroundColor Green
Write-Host ""
Write-Host "FLUXO COMPLETO:" -ForegroundColor Yellow
Write-Host "  1. Primeiro login (Google ou email/senha) -> home" -ForegroundColor White
Write-Host "  2. Home detecta que nunca perguntamos -> dialog pergunta" -ForegroundColor White
Write-Host "  3. Se Sim -> pede biometria pra confirmar -> ativa" -ForegroundColor White
Write-Host "  4. Se Nao -> marca como perguntado (nunca insiste)" -ForegroundColor White
Write-Host "  5. Proxima abertura do app com sessao ativa + biometria -> /unlock" -ForegroundColor White
Write-Host "  6. Biometria OK -> home" -ForegroundColor White
Write-Host "  7. Biometria falha/cancela -> logout + /login" -ForegroundColor White
Write-Host ""
Write-Host "CHECKLIST:" -ForegroundColor Yellow
Write-Host "  [ ] pubspec.yaml: local_auth ^2.3.0, shared_preferences ^2.3.2" -ForegroundColor White
Write-Host "  [ ] AndroidManifest: USE_BIOMETRIC e USE_FINGERPRINT" -ForegroundColor White
Write-Host "  [ ] MainActivity.kt: FlutterFragmentActivity" -ForegroundColor White
Write-Host ""
Write-Host "  flutter clean && flutter pub get && flutter run" -ForegroundColor White
