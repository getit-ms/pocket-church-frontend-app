part of pocket_church.model.cantico;

@JsonSerializable()
class Cantico {
  int id;
  String autor;
  String titulo;
  Arquivo cifra;
  Arquivo thumbnail;

  
  
  Cantico({this.id, this.autor, this.titulo, this.cifra, this.thumbnail});

  factory Cantico.fromJson(Map<String, dynamic> json) => _$CanticoFromJson(json);

  Map<String, dynamic> toJson() => _$CanticoToJson(this);
}