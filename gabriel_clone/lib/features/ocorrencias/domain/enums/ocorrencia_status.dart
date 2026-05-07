/// Status de ciclo de vida de uma ocorrência, do ponto de vista do usuário.
///
/// Pipeline:
///   pendingUpload → syncing → pendingReview → emAnalise → publicado/rejeitado
///
/// [pendingUpload]  — salvo localmente, ainda não enviado ao servidor.
/// [syncing]        — upload em progresso.
/// [uploadFailed]   — upload falhou, aguardando retry.
/// [deadLetter]     — número máximo de tentativas atingido (requer ação manual).
/// [pendingReview]  — recebido pelo servidor, aguardando análise/moderação.
/// [emAnalise]      — em análise pela equipe Gabriel.
/// [publicado]      — aprovado e publicado como alerta público no mapa.
/// [rejeitado]      — rejeitado pela moderação (ex.: fora da área, inválido).
/// [concluido]      — processo encerrado (investigação concluída).
enum OcorrenciaStatus {
  /// Salvo localmente, fila de upload.
  pendingUpload,

  /// Upload em andamento.
  syncing,

  /// Upload falhou; será reentado automaticamente.
  uploadFailed,

  /// Número máximo de tentativas atingido; requer ação manual.
  deadLetter,

  /// Recebido pelo servidor, aguarda triagem.
  pendingReview,

  /// Em análise pela equipe Gabriel.
  emAnalise,

  /// Ocorrência aprovada e publicada como alerta.
  publicado,

  /// Ocorrência rejeitada pela moderação.
  rejeitado,

  /// Processo encerrado (investigação finalizada).
  concluido,
}

extension OcorrenciaStatusX on OcorrenciaStatus {
  /// Rótulo legível para exibição na UI.
  String get label => switch (this) {
        OcorrenciaStatus.pendingUpload => 'Pendente de envio',
        OcorrenciaStatus.syncing => 'Enviando…',
        OcorrenciaStatus.uploadFailed => 'Erro no envio',
        OcorrenciaStatus.deadLetter => 'Falha permanente',
        OcorrenciaStatus.pendingReview => 'Em análise',
        OcorrenciaStatus.emAnalise => 'Em análise',
        OcorrenciaStatus.publicado => 'Publicado',
        OcorrenciaStatus.rejeitado => 'Rejeitado',
        OcorrenciaStatus.concluido => 'Concluído',
      };

  /// `true` quando o status é terminal e não requer mais ação do worker.
  bool get isTerminal =>
      this == OcorrenciaStatus.publicado ||
      this == OcorrenciaStatus.rejeitado ||
      this == OcorrenciaStatus.concluido ||
      this == OcorrenciaStatus.deadLetter;

  /// `true` quando ainda é possível enviar/reenviar.
  bool get isRetryable =>
      this == OcorrenciaStatus.uploadFailed ||
      this == OcorrenciaStatus.deadLetter;

  /// Converte a string do Firestore no enum.
  static OcorrenciaStatus fromRemoteString(String? value) {
    return switch (value) {
      'em_andamento' || 'pending_review' => OcorrenciaStatus.pendingReview,
      'em_analise' => OcorrenciaStatus.emAnalise,
      'publicado' => OcorrenciaStatus.publicado,
      'rejeitado' || 'invalido' => OcorrenciaStatus.rejeitado,
      'concluido' => OcorrenciaStatus.concluido,
      _ => OcorrenciaStatus.pendingReview,
    };
  }

  /// Converte o status da fila local no enum.
  static OcorrenciaStatus fromLocalQueueStatus(String? value) {
    return switch (value) {
      'queued' => OcorrenciaStatus.pendingUpload,
      'syncing' => OcorrenciaStatus.syncing,
      'failed' => OcorrenciaStatus.uploadFailed,
      'deadLetter' => OcorrenciaStatus.deadLetter,
      'synced' => OcorrenciaStatus.pendingReview,
      _ => OcorrenciaStatus.pendingUpload,
    };
  }
}
