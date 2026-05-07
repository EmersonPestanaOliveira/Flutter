abstract final class AuthValidators {
  static String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha este campo.';
    }
    return null;
  }

  static String? requiredEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Informe seu e-mail.';
    }
    if (!email.contains('@')) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  static String? requiredPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe sua senha.';
    }
    if (value.length < 6) {
      return 'A senha precisa ter pelo menos 6 caracteres.';
    }
    return null;
  }
}
