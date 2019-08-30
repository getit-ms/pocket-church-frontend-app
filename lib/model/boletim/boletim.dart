part of pocket_church.model.boletim;

@JsonSerializable()
class Boletim {
  int id;
  String titulo;
  DateTime data;
  DateTime dataPublicacao;
  Arquivo boletim;
  Arquivo thumbnail;

  Boletim({this.id, this.titulo, this.data, this.dataPublicacao, this.boletim, this.thumbnail});

  factory Boletim.fromJson(Map<String, dynamic> json) => _$BoletimFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'titulo': titulo,
    'data': data?.toIso8601String(),
    'dataPublicacao': dataPublicacao?.toIso8601String(),
    'boletim': boletim.toJson(),
    'thumbnail': thumbnail.toJson(),
  };
}