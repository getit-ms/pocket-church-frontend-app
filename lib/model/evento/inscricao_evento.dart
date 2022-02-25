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

  factory InscricaoEvento.fromJson(Map<String, dynamic> json) {
    return InscricaoEvento(
      id: json['id'] as int,
      membro: json['membro'] == null
          ? null
          : Membro.fromJson(json['membro'] as Map<String, dynamic>),
      nomeInscrito: json['nomeInscrito'] as String,
      emailInscrito: json['emailInscrito'] as String,
      telefoneInscrito: json['telefoneInscrito'] as String,
      referenciaCheckout: json['referenciaCheckout'] as String,
      chaveCheckout: json['chaveCheckout'] as String,
      data: json['data'] == null ? null : DateTime.parse(json['data'] as String)?.toLocal(),
      valor: (json['valor'] as num)?.toDouble(),
      status: json['status'] as String,
      confirmada: json['confirmada'] as bool,
      pendente: json['pendente'] as bool,
      valores: (json['valores'] as List)
          ?.map((e) => e == null
          ? null
          : ValorInscricaoEvento.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nomeInscrito': nomeInscrito,
        'emailInscrito': emailInscrito,
        'telefoneInscrito': telefoneInscrito,
        'valores': valores?.map((e) => e.toJson())?.toList(),
      };
}
