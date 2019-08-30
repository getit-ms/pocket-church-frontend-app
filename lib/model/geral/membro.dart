part of pocket_church.model.geral;

@JsonSerializable()
class Membro {
  int id;
  String nome;
  String email;
  DateTime dataNascimento;
  List<String> telefones;
  bool pastor;
  bool visitante;
  Endereco endereco;
  Arquivo foto;
  int diaAniversario;
  
  
  Membro({this.id, this.nome, this.email, this.dataNascimento, this.telefones, this.pastor, this.visitante, this.endereco, this.foto, this.diaAniversario});

  factory Membro.fromJson(Map<String, dynamic> json) => _$MembroFromJson(json);

  Map<String, dynamic> toJson() => _$MembroToJson(this);
}