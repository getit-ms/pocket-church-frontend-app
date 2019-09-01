part of pocket_church.model.audio;

@JsonSerializable()
class Audio {
  int id;
  String nome;
  String autor;
  String descricao;
  int tamamnhoArquivo;
  int tempoAudio;
  Arquivo capa;
  Arquivo audio;
  DateTime dataCadastro;

  Audio({
    this.id,
    this.nome,
    this.autor,
    this.descricao,
    this.tamamnhoArquivo,
    this.tempoAudio,
    this.capa,
    this.audio,
    this.dataCadastro,
  });

  operator == (other) {
    return other is Audio && id == other.id;
  }

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);

  Map<String, dynamic> toJson() => _$AudioToJson(this);
}