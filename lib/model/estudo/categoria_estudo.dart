part of pocket_church.model.estudo;

@JsonSerializable()
class CategoriaEstudo {
  int id;
  String nome;
  
  CategoriaEstudo({this.id, this.nome});

  factory CategoriaEstudo.fromJson(Map<String, dynamic> json) => _$CategoriaEstudoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriaEstudoToJson(this);
}