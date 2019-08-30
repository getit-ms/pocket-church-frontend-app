part of pocket_church.model.enquete;

@JsonSerializable()
class RespostaOpcao {
  Opcao opcao;

  RespostaOpcao({this.opcao});

  factory RespostaOpcao.fromJson(Map<String, dynamic> json) => _$RespostaOpcaoFromJson(json);

  Map<String, dynamic> toJson() => _$RespostaOpcaoToJson(this);
}