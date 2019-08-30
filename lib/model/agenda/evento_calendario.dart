part of pocket_church.model.agenda;

@JsonSerializable()
class EventoCalendario {
  String id;
  DateTime inicio;
  DateTime termino;
  String descricao;
  String local;


  EventoCalendario({this.id, this.inicio, this.termino, this.descricao, this.local});

  EventoCalendario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inicio = DateTime.parse(json['inicio']).toLocal();
    termino = DateTime.parse(json['termino']).toLocal();
    descricao = json['descricao'];
    local = json['local'];
  }

  Map<String, dynamic> toJson() => _$EventoCalendarioToJson(this);
}