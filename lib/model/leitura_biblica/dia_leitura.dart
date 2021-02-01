part of pocket_church.model.leitura_biblica;

@JsonSerializable()
class DiaLeitura {
  int id;
  DateTime data;
  String descricao;
  
  
  DiaLeitura({this.id, this.data, this.descricao});

  factory DiaLeitura.fromJson(Map<String, dynamic> json) => _$DiaLeituraFromJson(json);

  Map<String, dynamic> toJson() => _$DiaLeituraToJson(this);
}