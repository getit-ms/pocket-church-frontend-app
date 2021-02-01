// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.pedido_oracao;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedidoOracao _$PedidoOracaoFromJson(Map<String, dynamic> json) {
  return PedidoOracao(
    id: json['id'] as int,
    dataSolicitacao: json['dataSolicitacao'] == null
        ? null
        : DateTime.parse(json['dataSolicitacao'] as String),
    dataAtendimento: json['dataAtendimento'] == null
        ? null
        : DateTime.parse(json['dataAtendimento'] as String),
    nome: json['nome'] as String,
    email: json['email'] as String,
    pedido: json['pedido'] as String,
  );
}

Map<String, dynamic> _$PedidoOracaoToJson(PedidoOracao instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataSolicitacao': instance.dataSolicitacao?.toIso8601String(),
      'dataAtendimento': instance.dataAtendimento?.toIso8601String(),
      'nome': instance.nome,
      'email': instance.email,
      'pedido': instance.pedido,
    };
