part of pocket_church.model.sugestao;

@JsonSerializable()
class Sugestao {
  int id;
  String descricao;
  DateTime dataSolicitacao;
  String nomeSolicitante;
  String emailSolicitante;
  String status;
  String tipo;
  DateTime dataResposta;
  DateTime dataConclusao;

  Sugestao({
    this.id,
    this.descricao,
    this.dataSolicitacao,
    this.nomeSolicitante,
    this.emailSolicitante,
    this.status,
    this.tipo,
    this.dataResposta,
    this.dataConclusao,
  });

  factory Sugestao.fromJson(Map<String, dynamic> json) =>
      _$SugestaoFromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'dataConclusao': StringUtil.formatIso(dataConclusao),
        'dataResposta': StringUtil.formatIso(dataResposta),
        'dataSolicitacao': StringUtil.formatIso(dataSolicitacao),
        'nomeSolicitante': nomeSolicitante,
        'emailSolicitante': emailSolicitante,
        'status': status,
        'tipo': tipo,
      };
}
