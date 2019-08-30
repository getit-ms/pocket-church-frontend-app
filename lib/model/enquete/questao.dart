part of pocket_church.model.enquete;

@JsonSerializable()
class Questao {
  int id;
  String questao;
  int quantidadeVotos;
  List<Opcao> opcoes;
  
  
  Questao({this.id, this.questao, this.quantidadeVotos, this.opcoes});

  factory Questao.fromJson(Map<String, dynamic> json) => _$QuestaoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestaoToJson(this);
}