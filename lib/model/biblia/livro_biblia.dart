part of pocket_church.model.biblia;

@JsonSerializable()
class LivroBiblia {
  int id;
  String nome;
  int ordem;
  String abreviacao;
  DateTime ultimaAtualizacao;
  String testamento;
  List<VersiculoBiblia> versiculos;

  LivroBiblia({
    this.id,
    this.nome,
    this.ordem,
    this.abreviacao,
    this.ultimaAtualizacao,
    this.testamento,
    this.versiculos,
  });

  operator == (other) {
    return other is LivroBiblia && id == other.id;
  }

  factory LivroBiblia.fromJson(Map<String, dynamic> json) =>
      _$LivroBibliaFromJson(json);

  Map<String, dynamic> toJson() => _$LivroBibliaToJson(this);
}
