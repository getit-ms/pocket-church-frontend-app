part of pocket_church.model.evento;

@JsonSerializable()
class InscricaoEvento {
  int id;
  Membro membro;
  String nomeInscrito;
  String emailInscrito;
  String telefoneInscrito;
  String referenciaCheckout;
  String chaveCheckout;
  DateTime data;
  double valor;
  String status;
  bool confirmada;
  bool pendente;
  List<ValorInscricaoEvento> valores;

  InscricaoEvento({
    this.id,
    this.membro,
    this.nomeInscrito,
    this.emailInscrito,
    this.telefoneInscrito,
    this.referenciaCheckout,
    this.chaveCheckout,
    this.data,
    this.valor,
    this.status,
    this.confirmada,
    this.pendente,
    this.valores,
  });

  factory InscricaoEvento.fromJson(Map<String, dynamic> json) => _$InscricaoEventoFromJson(json);

  Map<String, dynamic> toJson() => _$InscricaoEventoToJson(this);
}
