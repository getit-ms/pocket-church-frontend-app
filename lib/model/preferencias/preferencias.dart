part of pocket_church.model.preferencias;

@JsonSerializable()
class Preferencias {
  bool desejaReceberVersiculosDiarios;
  String horaVersiculoDiario;

  bool dadosDisponiveis;

  bool desejaReceberNotificacoesVideos;

  bool desejaReceberNotificacoesDevocionario;
  String horaNotificacoesDevocional;

  bool desejaReceberLembreteLeitura;
  String horaLembreteLeitura;

  List<Ministerio> ministeriosInteresse;

  Preferencias({
    this.horaVersiculoDiario,
    this.dadosDisponiveis,
    this.desejaReceberLembreteLeitura,
    this.desejaReceberNotificacoesVideos,
    this.desejaReceberVersiculosDiarios,
    this.horaLembreteLeitura,
    this.ministeriosInteresse,
    this.desejaReceberNotificacoesDevocionario,
    this.horaNotificacoesDevocional,
  });

  factory Preferencias.fromJson(Map<String, dynamic> json) =>
      _$PreferenciasFromJson(json);

  Map<String, dynamic> toJson() => {
        'horaVersiculoDiario': horaVersiculoDiario,
        'dadosDisponiveis': dadosDisponiveis,
        'desejaReceberVersiculosDiarios': desejaReceberVersiculosDiarios,
        'desejaReceberNotificacoesVideos': desejaReceberNotificacoesVideos,
        'desejaReceberLembreteLeitura': desejaReceberLembreteLeitura,
        'horaLembreteLeitura': horaLembreteLeitura,
        'desejaReceberNotificacoesDevocionario':
            desejaReceberNotificacoesDevocionario,
        'horaNotificacoesDevocional': horaNotificacoesDevocional,
        'ministeriosInteresse': ministeriosInteresse
            .map((min) => {
                  'id': min.id,
                })
            ?.toList(),
      };
}
