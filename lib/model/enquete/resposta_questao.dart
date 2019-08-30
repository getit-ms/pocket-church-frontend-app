part of pocket_church.model.enquete;

@JsonSerializable()
class RespostaQuestao {
  Questao questao;
  List<RespostaOpcao> opcoes;
  int brancos;
  int nulos;
  
  
  RespostaQuestao({this.questao, this.opcoes, this.brancos = 0, this.nulos = 0});

  factory RespostaQuestao.fromJson(Map<String, dynamic> json) => _$RespostaQuestaoFromJson(json);

  Map<String, dynamic> toJson() => _$RespostaQuestaoToJson(this);
}