part of pocket_church.leitura;

class BarraProgressoLeitura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Column(
      children: <Widget>[
        InfoDivider(
          child: IntlText("leitura.progresso"),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: StreamBuilder<ProgressoLeitura>(
              stream: leituraBloc.leitura,
              builder: (context, snapshot) {
                return Row(
                  children: <Widget>[
                    Icon(
                      _icon(snapshot.data),
                      color: tema.primary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            child: Stack(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                  child: LinearProgressIndicator(
                                    value: (snapshot.data?.porcentagemHoje ?? 0) / 100,
                                    valueColor: AlwaysStoppedAnimation(tema.primary.withOpacity(.5)),
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: LinearProgressIndicator(
                                    value: (snapshot.data?.porcentagem ?? 0) / 100,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          DefaultTextStyle(
                            style: TextStyle(color: Colors.black54),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _labelProgresso(snapshot.data),
                                Text("${snapshot.data?.porcentagem?.round() ?? 0}%")
                              ],
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                );
              }),
        )
      ],
    );
  }

  IconData _icon(ProgressoLeitura data) {
    if (data?.concluido ?? false) {
      return FontAwesomeIcons.checkCircle;
    }

    if (data?.emDia ?? false) {
      return FontAwesomeIcons.smile;
    }

    return FontAwesomeIcons.sadTear;
  }

  Widget _labelProgresso(ProgressoLeitura data) {
    if (data?.concluido ?? false) {
      return IntlText("leitura.concluida");
    }

    if (data?.emDia ?? false) {
      return IntlText("leitura.em_dia");
    }

    return IntlText("leitura.atrasada");
  }
}
