part of pocket_church.model.hino;

@JsonSerializable()
class Hino {
  int id;
  String numero;
  String assunto;
  String autor;
  String nome;
  String texto;
  String filename;
  DateTime ultimaAlteracao;

  Hino({
    this.id,
    this.numero,
    this.assunto,
    this.autor,
    this.nome,
    this.texto,
    this.filename,
    this.ultimaAlteracao,
  });

  factory Hino.fromJson(Map<String, dynamic> json) => _$HinoFromJson(json);

  Map<String, dynamic> toJson() => _$HinoToJson(this);
}
