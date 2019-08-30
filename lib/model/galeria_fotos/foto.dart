part of pocket_church.model.galeria_fotos;

@JsonSerializable()
class Foto {
  String id;
  String server;
  String farm;
  String secret;
  String titulo;


  Foto({this.id, this.server, this.farm, this.secret, this.titulo});

  factory Foto.fromJson(Map<String, dynamic> json) => _$FotoFromJson(json);

  Map<String, dynamic> toJson() => _$FotoToJson(this);
}