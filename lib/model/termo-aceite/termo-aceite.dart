part of pocket_church.model.boletim;

@JsonSerializable()
class TermoAceite {
  int id;
  int versao;
  String termo;

  TermoAceite({this.id, this.versao, this.termo});

  factory TermoAceite.fromJson(Map<String, dynamic> json) => TermoAceite(
        id: json['id'],
        versao: json['vesao'],
        termo: json['termo'],
      );
}
