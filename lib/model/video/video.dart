part of pocket_church.model.video;

@JsonSerializable()
class Video {
  String id;
  String titulo;
  String descricao;
  String thumbnail;
  DateTime publicacao;
  DateTime agendamento;
  bool aoVivo;
  String streamUrl;
  bool agendado;
  
  
  Video({this.id, this.titulo, this.descricao, this.thumbnail, this.publicacao, this.agendamento, this.aoVivo, this.streamUrl, this.agendado});

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}