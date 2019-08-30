part of pocket_church.model.aconselhamento;

@JsonSerializable()
class EventoCalendarioAconselhamento {
  DateTime dataInicio;
  DateTime dataTermino;
  HorarioCalendarioAconselhamento horario;

  EventoCalendarioAconselhamento({
    DateTime dataInicio,
    DateTime dataTermino,
    this.horario,
  }) {
    this.dataInicio = dataInicio?.toLocal();
    this.dataTermino = dataTermino?.toLocal();
  }

  factory EventoCalendarioAconselhamento.fromJson(Map<String, dynamic> json) =>
      _$EventoCalendarioAconselhamentoFromJson(json);

  Map<String, dynamic> toJson() => _$EventoCalendarioAconselhamentoToJson(this);
}
