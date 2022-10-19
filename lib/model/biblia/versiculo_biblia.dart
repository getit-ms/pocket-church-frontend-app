part of pocket_church.model.biblia;

@JsonSerializable()
class VersiculoBiblia {
  int id;
  int capitulo;
  int versiculo;
  String texto;

  LivroCapitulo livroCapitulo;

  VersiculoBiblia({
    this.id,
    this.capitulo,
    this.versiculo,
    this.texto,
    this.livroCapitulo,
  });

  factory VersiculoBiblia.fromJson(Map<String, dynamic> json) =>
      _$VersiculoBibliaFromJson(json);

  Map<String, dynamic> toJson() => _$VersiculoBibliaToJson(this);

}
