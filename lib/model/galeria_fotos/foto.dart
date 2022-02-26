part of pocket_church.model.galeria_fotos;

@JsonSerializable()
class Foto {
  String id;
  String server;
  String farm;
  String secret;
  String titulo;
  String _urlImagemNormal;
  String _urlImagemGrande;

  Foto({
    this.id,
    this.server,
    this.farm,
    this.secret,
    this.titulo,
    String urlImagemNormal,
    String urlImagemGrande,
  }) {
    _urlImagemNormal = urlImagemNormal;
    _urlImagemGrande = urlImagemGrande;
  }

  factory Foto.fromJson(Map<String, dynamic> json) => _$FotoFromJson(json);

  String get urlImagemNormal =>
      _urlImagemNormal ??
      "https://farm$farm.staticflickr.com/$server/${id}_${secret}_n.jpg";

  String get urlImagemGrande =>
      _urlImagemGrande ??
      "https://farm$farm.staticflickr.com/$server/${id}_${secret}_b.jpg";

  Map<String, dynamic> toJson() => _$FotoToJson(this);
}
