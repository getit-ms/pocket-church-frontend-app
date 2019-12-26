part of pocket_church.model.devocionario;

@JsonSerializable()
class DiaDevocionario {
  int id;
  DateTime data;
  Arquivo arquivo;
  Arquivo thumbnail;

  DiaDevocionario({this.id, this.data, this.arquivo, this.thumbnail});

  factory DiaDevocionario.fromJson(Map<String, dynamic> json) => _$DiaDevocionarioFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'data': data?.toIso8601String(),
    'arquivo': arquivo.toJson(),
    'thumbnail': thumbnail.toJson(),
  };
}
