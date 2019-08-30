part of pocket_church.model.geral;

@JsonSerializable()
class Endereco {
  int id;
  String descricao;
  String cep;
  String cidade;
  String estado;

  Endereco({this.id, this.descricao, this.cep, this.cidade, this.estado});

  factory Endereco.fromJson(Map<String, dynamic> json) => _$EnderecoFromJson(json);

  Map<String, dynamic> toJson() => _$EnderecoToJson(this);
}