part of pocket_church.model.audio;

@JsonSerializable()
class CategoriaAudio {
  int id;
  String nome;
  
  CategoriaAudio({this.id, this.nome});

  factory CategoriaAudio.fromJson(Map<String, dynamic> json) => _$CategoriaAudioFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriaAudioToJson(this);
}