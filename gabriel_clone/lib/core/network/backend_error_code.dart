enum BackendErrorCode {
  networkOffline,
  networkPoor,
  timeout,
  unauthenticated,
  permissionDenied,
  notFound,
  alreadyExists,
  invalidArgument,
  failedPrecondition,
  aborted,
  outOfRange,
  unimplemented,
  internal,
  dataLoss,
  invalidEmail,
  invalidCredential,
  userDisabled,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  weakPassword,
  operationNotAllowed,
  requiresRecentLogin,
  quotaExceeded,
  canceled,
  tooManyRequests,
  unavailable,
  bucketNotFound,
  projectNotFound,
  invalidChecksum,
  storageObjectNotFound,
  uploadRetryLimitExceeded,
  googleSignInNotConfigured,
  pluginUnavailable,
  unknown;

  String get message {
    return switch (this) {
      BackendErrorCode.networkOffline =>
        'Sem conexao com a internet. Verifique sua rede e tente novamente.',
      BackendErrorCode.networkPoor =>
        'Sua conexao esta instavel. Tente novamente em alguns instantes.',
      BackendErrorCode.timeout =>
        'O servidor demorou para responder. Tente novamente.',
      BackendErrorCode.unauthenticated =>
        'Sua sessao expirou. Entre novamente para continuar.',
      BackendErrorCode.permissionDenied =>
        'Voce nao tem permissao para realizar esta acao.',
      BackendErrorCode.notFound => 'Informacao nao encontrada.',
      BackendErrorCode.alreadyExists => 'Este registro ja existe.',
      BackendErrorCode.invalidArgument =>
        'Revise os dados informados e tente novamente.',
      BackendErrorCode.failedPrecondition =>
        'Nao foi possivel concluir esta acao agora. Tente novamente.',
      BackendErrorCode.aborted =>
        'A operacao foi interrompida. Tente novamente.',
      BackendErrorCode.outOfRange =>
        'Valor fora do limite permitido.',
      BackendErrorCode.unimplemented =>
        'Recurso ainda nao disponivel no servidor.',
      BackendErrorCode.internal =>
        'Erro interno do servidor. Tente novamente mais tarde.',
      BackendErrorCode.dataLoss =>
        'Nao foi possivel ler os dados do servidor. Tente novamente.',
      BackendErrorCode.invalidEmail => 'E-mail invalido.',
      BackendErrorCode.invalidCredential => 'E-mail ou senha invalidos.',
      BackendErrorCode.userDisabled => 'Usuario desativado.',
      BackendErrorCode.userNotFound => 'Usuario nao encontrado.',
      BackendErrorCode.wrongPassword => 'Senha incorreta.',
      BackendErrorCode.emailAlreadyInUse => 'Este e-mail ja esta cadastrado.',
      BackendErrorCode.weakPassword =>
        'A senha precisa ter pelo menos 6 caracteres.',
      BackendErrorCode.operationNotAllowed =>
        'Metodo de login nao habilitado.',
      BackendErrorCode.requiresRecentLogin =>
        'Entre novamente na conta antes de concluir esta acao.',
      BackendErrorCode.quotaExceeded =>
        'Limite do servidor atingido. Tente novamente mais tarde.',
      BackendErrorCode.canceled => 'Operacao cancelada.',
      BackendErrorCode.tooManyRequests =>
        'Muitas tentativas em pouco tempo. Aguarde e tente novamente.',
      BackendErrorCode.unavailable =>
        'Servidor indisponivel. Tente novamente em instantes.',
      BackendErrorCode.bucketNotFound =>
        'Armazenamento nao encontrado no servidor.',
      BackendErrorCode.projectNotFound =>
        'Projeto do servidor nao encontrado.',
      BackendErrorCode.invalidChecksum =>
        'Falha ao validar o arquivo enviado. Tente novamente.',
      BackendErrorCode.storageObjectNotFound =>
        'Arquivo nao encontrado no servidor.',
      BackendErrorCode.uploadRetryLimitExceeded =>
        'Falha de conexao ao enviar o arquivo. Tente novamente.',
      BackendErrorCode.googleSignInNotConfigured =>
        'Login Google nao configurado. Verifique as credenciais do Firebase.',
      BackendErrorCode.pluginUnavailable =>
        'Reinstale o app para carregar este recurso.',
      BackendErrorCode.unknown =>
        'Ocorreu um erro inesperado. Tente novamente.',
    };
  }

  static BackendErrorCode fromServerCode(String? code) {
    final normalized = code?.trim().toLowerCase();
    return switch (normalized) {
      null || '' => BackendErrorCode.unknown,
      '400' => BackendErrorCode.invalidArgument,
      '401' => BackendErrorCode.unauthenticated,
      '403' => BackendErrorCode.permissionDenied,
      '404' => BackendErrorCode.notFound,
      '408' => BackendErrorCode.timeout,
      '409' => BackendErrorCode.alreadyExists,
      '422' => BackendErrorCode.invalidArgument,
      '429' => BackendErrorCode.tooManyRequests,
      '500' => BackendErrorCode.internal,
      '503' => BackendErrorCode.unavailable,
      'network-request-failed' => BackendErrorCode.networkOffline,
      'network_error' => BackendErrorCode.networkOffline,
      'unavailable' => BackendErrorCode.networkPoor,
      'deadline-exceeded' => BackendErrorCode.timeout,
      'timeout' => BackendErrorCode.timeout,
      'cancelled' => BackendErrorCode.canceled,
      'unauthenticated' => BackendErrorCode.unauthenticated,
      'storage/unauthenticated' => BackendErrorCode.unauthenticated,
      'user-token-expired' => BackendErrorCode.unauthenticated,
      'permission-denied' => BackendErrorCode.permissionDenied,
      'unauthorized' => BackendErrorCode.permissionDenied,
      'storage/unauthorized' => BackendErrorCode.permissionDenied,
      'not-found' => BackendErrorCode.notFound,
      'user-profile-not-found' => BackendErrorCode.notFound,
      'object-not-found' => BackendErrorCode.storageObjectNotFound,
      'storage/object-not-found' => BackendErrorCode.storageObjectNotFound,
      'already-exists' => BackendErrorCode.alreadyExists,
      'account-exists-with-different-credential' =>
        BackendErrorCode.alreadyExists,
      'credential-already-in-use' => BackendErrorCode.alreadyExists,
      'invalid-argument' => BackendErrorCode.invalidArgument,
      'missing-email' => BackendErrorCode.invalidEmail,
      'missing-password' => BackendErrorCode.invalidArgument,
      'invalid-continue-uri' => BackendErrorCode.invalidArgument,
      'invalid-action-code' => BackendErrorCode.invalidArgument,
      'expired-action-code' => BackendErrorCode.invalidArgument,
      'failed-precondition' => BackendErrorCode.failedPrecondition,
      'aborted' => BackendErrorCode.aborted,
      'out-of-range' => BackendErrorCode.outOfRange,
      'unimplemented' => BackendErrorCode.unimplemented,
      'internal' => BackendErrorCode.internal,
      'data-loss' => BackendErrorCode.dataLoss,
      'invalid-email' => BackendErrorCode.invalidEmail,
      'invalid-credential' => BackendErrorCode.invalidCredential,
      'invalid-verification-code' => BackendErrorCode.invalidCredential,
      'invalid-verification-id' => BackendErrorCode.invalidCredential,
      'user-disabled' => BackendErrorCode.userDisabled,
      'user-not-found' => BackendErrorCode.userNotFound,
      'wrong-password' => BackendErrorCode.wrongPassword,
      'email-already-in-use' => BackendErrorCode.emailAlreadyInUse,
      'weak-password' => BackendErrorCode.weakPassword,
      'operation-not-allowed' => BackendErrorCode.operationNotAllowed,
      'requires-recent-login' => BackendErrorCode.requiresRecentLogin,
      'resource-exhausted' => BackendErrorCode.quotaExceeded,
      'quota-exceeded' => BackendErrorCode.quotaExceeded,
      'storage/quota-exceeded' => BackendErrorCode.quotaExceeded,
      'too-many-requests' => BackendErrorCode.tooManyRequests,
      'canceled' => BackendErrorCode.canceled,
      'storage/canceled' => BackendErrorCode.canceled,
      'bucket-not-found' => BackendErrorCode.bucketNotFound,
      'storage/bucket-not-found' => BackendErrorCode.bucketNotFound,
      'project-not-found' => BackendErrorCode.projectNotFound,
      'storage/project-not-found' => BackendErrorCode.projectNotFound,
      'invalid-checksum' => BackendErrorCode.invalidChecksum,
      'storage/invalid-checksum' => BackendErrorCode.invalidChecksum,
      'retry-limit-exceeded' => BackendErrorCode.uploadRetryLimitExceeded,
      'storage/retry-limit-exceeded' =>
        BackendErrorCode.uploadRetryLimitExceeded,
      'sign_in_failed' => BackendErrorCode.googleSignInNotConfigured,
      'channel-error' => BackendErrorCode.pluginUnavailable,
      _ => BackendErrorCode.unknown,
    };
  }
}
