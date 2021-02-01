part of pocket_church.model.enquete;

@JsonSerializable()
class Opcao {
  int id;
  String opcao;

  Opcao({this.id, this.opcao});

  factory Opcao.fromJson(Map<String, dynamic> json) => _$OpcaoFromJson(json);

  Map<String, dynamic> toJson() => _$OpcaoToJson(this);
}