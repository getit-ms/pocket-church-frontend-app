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

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      limiteInscricoes: json['limiteInscricoes'] as int,
      tipo: json['tipo'] as String,
      dataHoraInicio: json['dataHoraInicio'] == null
          ? null
          : DateTime.parse(json['dataHoraInicio'] as String).toLocal(),
      dataHoraTermino: json['dataHoraTermino'] == null
          ? null
          : DateTime.parse(json['dataHoraTermino'] as String).toLocal(),
      valor: (json['valor'] as num)?.toDouble(),
      exigePagamento: json['exigePagamento'] as bool,
      dataInicioInscricao: json['dataInicioInscricao'] == null
          ? null
          : DateTime.parse(json['dataInicioInscricao'] as String).toLocal(),
      dataTerminoInscricao: json['dataTerminoInscricao'] == null
          ? null
          : DateTime.parse(json['dataTerminoInscricao'] as String).toLocal(),
      banner: json['banner'] == null
          ? null
          : Arquivo.fromJson(json['banner'] as Map<String, dynamic>),
      vagasRestantes: json['vagasRestantes'] as int,
      inscricoesFuturas: json['inscricoesFuturas'] as bool,
      inscricoesPassadas: json['inscricoesPassadas'] as bool,
      inscricoesAbertas: json['inscricoesAbertas'] as bool,
      filename: json['filename'] as String,
      comPagamento: json['comPagamento'] as bool,
      campos: (json['campos'] as List)
          ?.map((e) => e == null
              ? null
              : CampoEvento.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() => _$EventoToJson(this);
}
