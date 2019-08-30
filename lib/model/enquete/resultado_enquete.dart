part of pocket_church.model.enquete;

@JsonSerializable()
class ResultadoEnquete {
  int id;
  String nome;
  String descricao;
  List<ResultadoQuestao> questoes;

  
  ResultadoEnquete({this.id, this.nome, this.descricao, this.questoes});

  factory ResultadoEnquete.fromJson(Map<String, dynamic> json) => _$ResultadoEnqueteFromJson(json);

  Map<String, dynamic> toJson() => _$ResultadoEnqueteToJson(this);
}