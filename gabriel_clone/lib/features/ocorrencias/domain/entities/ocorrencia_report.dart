import 'package:equatable/equatable.dart';

import '../enums/ocorrencia_status.dart';

/// Representa uma ocorrência que já chegou ao servidor (Firestore).
///
/// Diferente de [PendingOcorrencia] (fila local), esta entidade só existe
/// depois do sync bem-sucedido. É usada na tela "Meus Relatos" para mostrar
/// o status pós-envio e o vínculo com o alerta público (se publicado).
class OcorrenciaReport extends Equatable {
  const OcorrenciaReport({
    required this.id,
    required this.userId,
    required this.informacoes,
    required this.quando,
    required this.horario,
    required this.status,
    this.latitude,
    this.longitude,
    this.enderecoBusca,
    this.createdAt,
    this.updatedAt,
    this.descricao,
    /// ID do alerta público gerado a partir desta ocorrência.
    /// Preenchido apenas quando [status] == [OcorrenciaStatus.publicado].
    this.publishedAlertId,
  });

  final String id;
  final String userId;
  final String informacoes;
  final DateTime quando;
  final String horario;
  final OcorrenciaStatus status;
  final double? latitude;
  final double? longitude;
  final String? enderecoBusca;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? descricao;

  /// ID do alerta público correspondente (preenchido após moderação/publicação).
  final String? publishedAlertId;

  /// `true` quando a ocorrência foi publicada e gerou um alerta visível no mapa.
  bool get isPublished => status == OcorrenciaStatus.publicado && publishedAlertId != null;

  OcorrenciaReport copyWith({
    String? id,
    String? userId,
    String? informacoes,
    DateTime? quando,
    String? horario,
    OcorrenciaStatus? status,
    double? latitude,
    double? longitude,
    String? enderecoBusca,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? descricao,
    String? publishedAlertId,
  }) {
    return OcorrenciaReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      informacoes: informacoes ?? this.informacoes,
      quando: quando ?? this.quando,
      horario: horario ?? this.horario,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      enderecoBusca: enderecoBusca ?? this.enderecoBusca,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      descricao: descricao ?? this.descricao,
      publishedAlertId: publishedAlertId ?? this.publishedAlertId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        informacoes,
        quando,
        horario,
        status,
        latitude,
        longitude,
        enderecoBusca,
        createdAt,
        updatedAt,
        descricao,
        publishedAlertId,
      ];
}
