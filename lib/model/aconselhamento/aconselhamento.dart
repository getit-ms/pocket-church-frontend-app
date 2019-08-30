part of pocket_church.model.aconselhamento;

@JsonSerializable()
class Aconselhamento {
  int id;
  Membro membro;
  String status;
  bool concluido;
  bool confirmado;
  CalendarioAconselhamento calendario;
  DateTime dataHoraInicio;
  DateTime dataHoraFim;

  Aconselhamento({
    this.id,
    this.membro,
    this.status,
    this.concluido,
    this.confirmado,
    this.calendario,
    this.dataHoraInicio,
    this.dataHoraFim,
  });

  factory Aconselhamento.fromJson(Map<String, dynamic> json) =>
      _$AconselhamentoFromJson(json);

  Map<String, dynamic> toJson() => _$AconselhamentoToJson(this);
}
