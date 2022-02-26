part of pocket_church.model.item_evento;

class DenunciaComentario {
  String justificativa;

  DenunciaComentario({this.justificativa});

  Map<String, dynamic> toJson() {
    return {
      'justificativa': justificativa,
    };
  }
}
