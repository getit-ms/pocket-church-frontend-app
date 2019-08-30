part of pocket_church.model.enquete;

@JsonSerializable()
class Enquete {
  int id;
  String nome;
  String descricao;
  DateTime dataInicio;
  DateTime dataTermino;
  List<Questao> questoes;
  bool respondido;
  bool encerrado;
  
  
  Enquete({this.id, this.nome, this.descricao, this.dataInicio, this.dataTermino, this.questoes, this.respondido, this.encerrado});

  factory Enquete.fromJson(Map<String, dynamic> json) => _$EnqueteFromJson(json);

  Map<String, dynamic> toJson() => _$EnqueteToJson(this);
}