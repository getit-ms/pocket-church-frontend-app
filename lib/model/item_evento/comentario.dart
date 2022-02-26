part of pocket_church.model.item_evento;

class Comentario {
  int id;
  DateTime dataHora;
  String comentario;
  Membro membro;

  Comentario({this.id, this.dataHora, this.comentario, this.membro});

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
        id: json['id'],
        dataHora: json['dataHora'] != null
            ? DateTime.parse(json['dataHora']).toLocal()
            : null,
        membro: json['membro'] != null
            ? Membro.fromJson(json['membro'])
            : null,
        comentario: json['comentario'],
      );

  Map<String, dynamic> toJson() {
    return {
      'comentario': comentario,
    };
  }
}
