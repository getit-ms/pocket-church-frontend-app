part of pocket_church.model.enquete;

@JsonSerializable()
class ResultadoQuestao {
  String questao;
  List<ResultadoOpcao> validos;
  List<ResultadoOpcao> totais;

  ResultadoQuestao({this.questao, this.validos, this.totais});

  factory ResultadoQuestao.fromJson(Map<String, dynamic> json) => _$ResultadoQuestaoFromJson(json);

  Map<String, dynamic> toJson() => _$ResultadoQuestaoToJson(this);
}