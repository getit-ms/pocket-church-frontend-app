part of pocket_church.model.pedido_oracao;

@JsonSerializable()
class PedidoOracao {
  int id;
  DateTime dataSolicitacao;
  DateTime dataAtendimento;
  String nome;
  String email;
  String pedido;

  PedidoOracao({
    this.id,
    this.dataSolicitacao,
    this.dataAtendimento,
    this.nome,
    this.email,
    this.pedido,
  });

  factory PedidoOracao.fromJson(Map<String, dynamic> json) =>
      _$PedidoOracaoFromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'dataSolicitacao': StringUtil.formatIso(dataSolicitacao),
        'dataAtendimento': StringUtil.formatIso(dataAtendimento),
        'nome': nome,
        'email': email,
        'pedido': pedido,
      };
}
