part of pocket_church.model.estudo;

@JsonSerializable()
class Estudo {
  int id;
  String titulo;
  String texto;
  DateTime data;
  Arquivo pdf;
  Arquivo thumbnail;
  String autor;
  String filename;
  String tipo;

  Estudo({this.id, this.titulo, this.texto, this.data, this.pdf, this.thumbnail,
    this.autor, this.filename, this.tipo});

  factory Estudo.fromJson(Map<String, dynamic> json) => _$EstudoFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'titulo': titulo,
    'texto': texto,
    'data': data?.toIso8601String(),
    'pdf': pdf?.toJson(),
    'thumbnail': thumbnail?.toJson(),
    'autor': autor,
    'filename': filename,
    'tipo': tipo,
  };
}