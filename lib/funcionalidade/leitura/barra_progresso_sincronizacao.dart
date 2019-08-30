part of pocket_church.leitura;

class BarraProgressoSincronizacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return StreamBuilder<ProgressoSincronismo>(
      stream: leituraBloc.sincronizacao,
      builder: (context, snapshot) {
        return AnimatedCrossFade(
          firstChild: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: CommandButton(
              child: IntlText("leitura.trocar_plano_leitura"),
              onPressed: (loading) {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => PageListaPlanos(),
                );
              },
            ),
          ),
          secondChild: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                IntlText(
                  "leitura.sincronizando",
                  args: {
                    'porcentagem':
                        (snapshot.data?.porcentagem ?? 0).floor().toString()
                  },
                  style: TextStyle(
                    fontSize: 15,
                    color: tema.primary,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: (snapshot.data?.porcentagem ?? 0) / 100,
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: (snapshot.data?.sincronizando ?? false)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
