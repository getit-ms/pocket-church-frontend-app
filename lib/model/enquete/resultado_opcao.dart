part of pocket_church.model.enquete;

@JsonSerializable()
class ResultadoOpcao {
  String opcao;
  int resultado;

  ResultadoOpcao({this.opcao, this.resultado});

  factory ResultadoOpcao.fromJson(Map<String, dynamic> json) => _$ResultadoOpcaoFromJson(json);

  Map<String, dynamic> toJson() => _$ResultadoOpcaoToJson(this);
}