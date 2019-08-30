part of pocket_church.model.geral;

@JsonSerializable()
class Arquivo {
  int id;
  String nome;
  String filename;

  Arquivo({this.id, this.nome, this.filename});

  Arquivo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        filename = json['filename'];

  Map<String, dynamic> toJson() => _$ArquivoToJson(this);
}
