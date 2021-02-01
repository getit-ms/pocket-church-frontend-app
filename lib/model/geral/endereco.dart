part of pocket_church.model.geral;

@JsonSerializable()
class Endereco {
  int id;
  String descricao;
  String cep;
  String cidade;
  String estado;

  Endereco({this.id, this.descricao, this.cep, this.cidade, this.estado});

  factory Endereco.fromJson(Map<String, dynamic> json) {
    if (json['descricao'] == null) {
      return null;
    }

    return Endereco(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      cep: json['cep'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$EnderecoToJson(this);
}