part of pocket_church.model.evento;

@JsonSerializable()
class ResultadoInscricao {
  String checkoutPagSeguro;
  bool devePagar;

  ResultadoInscricao({this.checkoutPagSeguro, this.devePagar});

  factory ResultadoInscricao.fromJson(Map<String, dynamic> json) => _$ResultadoInscricaoFromJson(json);

  Map<String, dynamic> toJson() => _$ResultadoInscricaoToJson(this);

}

