part of pocket_church.model.aconselhamento;

@JsonSerializable()
class HorarioCalendarioAconselhamento {
  int id;
  String horaInicio;
  String horaFim;

  HorarioCalendarioAconselhamento({
    this.id,
    this.horaInicio,
    this.horaFim,
  });

  factory HorarioCalendarioAconselhamento.fromJson(Map<String, dynamic> json) =>
      _$HorarioCalendarioAconselhamentoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HorarioCalendarioAconselhamentoToJson(this);
}
