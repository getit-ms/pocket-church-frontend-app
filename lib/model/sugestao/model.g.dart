// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.sugestao;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sugestao _$SugestaoFromJson(Map<String, dynamic> json) {
  return Sugestao(
    id: json['id'] as int,
    descricao: json['descricao'] as String,
    dataSolicitacao: json['dataSolicitacao'] == null
        ? null
        : DateTime.parse(json['dataSolicitacao'] as String),
    nomeSolicitante: json['nomeSolicitante'] as String,
    emailSolicitante: json['emailSolicitante'] as String,
    status: json['status'] as String,
    tipo: json['tipo'] as String,
    dataResposta: json['dataResposta'] == null
        ? null
        : DateTime.parse(json['dataResposta'] as String),
    dataConclusao: json['dataConclusao'] == null
        ? null
        : DateTime.parse(json['dataConclusao'] as String),
  );
}

Map<String, dynamic> _$SugestaoToJson(Sugestao instance) => <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'dataSolicitacao': instance.dataSolicitacao?.toIso8601String(),
      'nomeSolicitante': instance.nomeSolicitante,
      'emailSolicitante': instance.emailSolicitante,
      'status': instance.status,
      'tipo': instance.tipo,
      'dataResposta': instance.dataResposta?.toIso8601String(),
      'dataConclusao': instance.dataConclusao?.toIso8601String(),
    };
