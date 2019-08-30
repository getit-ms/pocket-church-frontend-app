// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.notificacao;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notificacao _$NotificacaoFromJson(Map<String, dynamic> json) {
  return Notificacao(
    id: json['id'] as int,
    data: json['data'] == null ? null : DateTime.parse(json['data'] as String),
    notificacao: json['notificacao'] as String,
  );
}

Map<String, dynamic> _$NotificacaoToJson(Notificacao instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data?.toIso8601String(),
      'notificacao': instance.notificacao,
    };
