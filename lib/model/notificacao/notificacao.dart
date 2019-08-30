part of pocket_church.model.notificacao;

@JsonSerializable()
class Notificacao {
  int id;
  DateTime data;
  String notificacao;


  Notificacao({this.id, this.data, this.notificacao});

  factory Notificacao.fromJson(Map<String, dynamic> json) => _$NotificacaoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificacaoToJson(this);
}