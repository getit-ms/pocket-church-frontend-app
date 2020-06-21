part of pocket_church.model.evento;

@JsonSerializable()
class Evento {
  int id;
  String nome;
  String descricao;
  int limiteInscricoes;
  String tipo;
  DateTime dataHoraInicio;
  DateTime dataHoraTermino;
  double valor;
  bool exigePagamento;
  DateTime dataInicioInscricao;
  DateTime dataTerminoInscricao;
  Arquivo banner;
  int vagasRestantes;
  bool inscricoesFuturas;
  bool inscricoesPassadas;
  bool inscricoesAbertas;
  String filename;
  bool comPagamento;
  List<CampoEvento> campos;

  Evento({
    this.id,
    this.nome,
    this.descricao,
    this.limiteInscricoes,
    this.tipo,
    this.dataHoraInicio,
    this.dataHoraTermino,
    this.valor,
    this.exigePagamento,
    this.dataInicioInscricao,
    this.dataTerminoInscricao,
    this.banner,
    this.vagasRestantes,
    this.inscricoesFuturas,
    this.inscricoesPassadas,
    this.inscricoesAbertas,
    this.filename,
    this.comPagamento,
    this.campos,
  }) {
    this.dataHoraInicio = dataHoraInicio?.toLocal();
    this.dataHoraTermino = dataHoraTermino?.toLocal();
    this.dataInicioInscricao = dataInicioInscricao?.toLocal();
    this.dataTerminoInscricao = dataTerminoInscricao?.toLocal();
  }

  factory Evento.fromJson(Map<String, dynamic> json) => _$EventoFromJson(json);

  Map<String, dynamic> toJson() => _$EventoToJson(this);
}
