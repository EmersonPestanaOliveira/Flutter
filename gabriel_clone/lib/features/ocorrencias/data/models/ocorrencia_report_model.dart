import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/ocorrencia_report.dart';
import '../../domain/enums/ocorrencia_status.dart';

/// Model que faz a ponte entre Firestore e [OcorrenciaReport].
///
/// Firestore permanece **exclusivo** desta camada (data).
/// A camada de domínio não conhece [DocumentSnapshot] nem [Timestamp].
class OcorrenciaReportModel extends OcorrenciaReport {
  const OcorrenciaReportModel({
    required super.id,
    required super.userId,
    required super.informacoes,
    required super.quando,
    required super.horario,
    required super.status,
    super.latitude,
    super.longitude,
    super.enderecoBusca,
    super.createdAt,
    super.updatedAt,
    super.descricao,
    super.publishedAlertId,
  });

  /// Constrói a partir de um documento Firestore.
  factory OcorrenciaReportModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    final rawWhen = data['quando'];
    final quando = rawWhen is Timestamp
        ? rawWhen.toDate()
        : DateTime.fromMillisecondsSinceEpoch(0);

    final rawCreated = data['createdAt'];
    final createdAt = rawCreated is Timestamp ? rawCreated.toDate() : null;

    final rawUpdated = data['updatedAt'];
    final updatedAt = rawUpdated is Timestamp ? rawUpdated.toDate() : null;

    return OcorrenciaReportModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      informacoes: data['informacoes'] as String? ?? '',
      quando: quando,
      horario: data['horario'] as String? ?? '',
      status: OcorrenciaStatusX.fromRemoteString(data['status'] as String?),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      enderecoBusca: data['enderecoBusca'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
      descricao: data['descricao'] as String?,
      publishedAlertId: data['publishedAlertId'] as String?,
    );
  }

  /// Serializa para envio ao Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'informacoes': informacoes,
      'quando': Timestamp.fromDate(quando),
      'horario': horario,
      'status': _statusToRemoteString(status),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (enderecoBusca != null) 'enderecoBusca': enderecoBusca,
      if (descricao != null) 'descricao': descricao,
      if (publishedAlertId != null) 'publishedAlertId': publishedAlertId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static String _statusToRemoteString(OcorrenciaStatus status) {
    return switch (status) {
      OcorrenciaStatus.pendingReview => 'pending_review',
      OcorrenciaStatus.emAnalise => 'em_analise',
      OcorrenciaStatus.publicado => 'publicado',
      OcorrenciaStatus.rejeitado => 'rejeitado',
      OcorrenciaStatus.concluido => 'concluido',
      _ => 'pending_review',
    };
  }
}
