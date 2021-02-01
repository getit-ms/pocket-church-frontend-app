part of pocket_church.model.enquete;

@JsonSerializable()
class RespostaEnquete {
  Enquete votacao;
  List<RespostaQuestao> respostas;
  
  
  RespostaEnquete({this.votacao, this.respostas});

  factory RespostaEnquete.fromJson(Map<String, dynamic> json) => _$RespostaEnqueteFromJson(json);

  Map<String, dynamic> toJson() => _$RespostaEnqueteToJson(this);
}