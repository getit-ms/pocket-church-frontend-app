part of pocket_church.timeline;

class Feed {
  final Funcionalidade funcionalidade;
  final dynamic id;
  final String titulo;
  final dynamic image;
  final DateTime data;
  final String autoria;
  final String descricao;
  final Map<String, dynamic> args;

  Feed({
    this.funcionalidade,
    this.id,
    this.titulo,
    this.image,
    this.data,
    this.autoria,
    this.descricao,
    this.args,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        id: json['id'],
        args: json['args'],
        titulo: json['titulo'],
        data: DateTime.fromMillisecondsSinceEpoch(json['data']),
        descricao: json['descricao'],
        image: json['image'],
        autoria: json['autoria'],
        funcionalidade: Funcionalidade.values
            .firstWhere((func) => func.toString() == json['funcionalidade']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'args': args,
        'titulo': titulo,
        'data': data.millisecondsSinceEpoch,
        'descricao': descricao,
        'image': image,
        'autoria': autoria,
        'funcionalidade': funcionalidade.toString(),
      };
}
