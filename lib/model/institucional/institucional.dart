part of pocket_church.model.institucional;

@JsonSerializable()
class Institucional {
  String email;
  String site;
  Map<String, String> redesSociais = Map();
  Arquivo divulgacao;
  String textoDivulgacao;
  String quemSomos;
  List<String> telefones;
  List<Endereco> enderecos;

  Institucional({this.email, this.site, this.redesSociais, this.divulgacao, this.textoDivulgacao, this.quemSomos, this.telefones, this.enderecos});

  factory Institucional.fromJson(Map<String, dynamic> json) => _$InstitucionalFromJson(json);

  Map<String, dynamic> toJson() => _$InstitucionalToJson(this);
}