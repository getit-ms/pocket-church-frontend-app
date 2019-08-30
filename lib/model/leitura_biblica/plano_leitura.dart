part of pocket_church.model.leitura_biblica;

@JsonSerializable()
class PlanoLeitura {
  int id;
  String descricao;
  
  
  PlanoLeitura({this.id, this.descricao});

  factory PlanoLeitura.fromJson(Map<String, dynamic> json) => _$PlanoLeituraFromJson(json);

  Map<String, dynamic> toJson() => _$PlanoLeituraToJson(this);
}