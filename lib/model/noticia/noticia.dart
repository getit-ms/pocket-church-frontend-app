part of pocket_church.model.noticia;

@JsonSerializable()
class Noticia {
  int id;
  DateTime dataPublicacao;
  String titulo;
  String texto;
  String resumo;
  Arquivo ilustracao;
  Membro autor;
  
  Noticia({this.id, this.dataPublicacao, this.titulo, this.texto, this.resumo, this.ilustracao, this.autor});

  factory Noticia.fromJson(Map<String, dynamic> json) => _$NoticiaFromJson(json);

  Map<String, dynamic> toJson() => _$NoticiaToJson(this);
}