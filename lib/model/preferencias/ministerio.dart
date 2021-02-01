part of pocket_church.model.preferencias;

@JsonSerializable()
class Ministerio {
  int id;
  String nome;


  Ministerio({
    this.id, this.nome
  });

  operator ==(other) {
    return other is Ministerio && other.id == id;
  }

  factory Ministerio.fromJson(Map<String, dynamic> json) => _$MinisterioFromJson(json);

  Map<String, dynamic> toJson() => _$MinisterioToJson(this);
}