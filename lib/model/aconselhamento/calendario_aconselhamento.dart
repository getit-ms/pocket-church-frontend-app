part of pocket_church.model.aconselhamento;

@JsonSerializable()
class CalendarioAconselhamento {
  int id;
  Membro pastor;

  CalendarioAconselhamento({this.id, this.pastor});

  factory CalendarioAconselhamento.fromJson(Map<String, dynamic> json) => _$CalendarioAconselhamentoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioAconselhamentoToJson(this);

  operator == (other) {
    if (other is CalendarioAconselhamento) {
      return id == other.id;
    }

    return false;
  }
}