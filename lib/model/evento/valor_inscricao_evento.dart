part of pocket_church.model.evento;

@JsonSerializable()
class ValorInscricaoEvento {
  String nome;
  FormatoCampoEvento formato;
  String valorTexto;
  double valorNumero;
  Arquivo valorAnexo;
  DateTime valorData;

  ValorInscricaoEvento({
    this.nome,
    this.formato,
    this.valorTexto,
    this.valorNumero,
    this.valorData,
    this.valorAnexo,
  }) {
    this.valorData = this.valorData?.toLocal();
  }

  factory ValorInscricaoEvento.fromJson(Map<String, dynamic> json) =>
      _$ValorInscricaoEventoFromJson(json);

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'formato': _$FormatoCampoEventoEnumMap[formato],
        'valorTexto': valorTexto,
        'valorNumero': valorNumero,
        'valorData': valorData?.toUtc()?.toIso8601String(),
        'valorAnexo': valorAnexo?.toJson(),
      };
}
