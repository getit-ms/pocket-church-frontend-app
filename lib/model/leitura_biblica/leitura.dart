part of pocket_church.model.leitura_biblica;

@JsonSerializable()
class Leitura {
  DiaLeitura dia;
  DateTime ultimaAlteracao;
  int plano;
  bool lido;
  
  
  Leitura({this.dia, this.ultimaAlteracao, this.plano, this.lido});

  factory Leitura.fromJson(Map<String, dynamic> json) => _$LeituraFromJson(json);

  Map<String, dynamic> toJson() => _$LeituraToJson(this);
}