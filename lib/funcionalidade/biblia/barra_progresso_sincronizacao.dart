part of pocket_church.biblia;

class BarraProgressoSincronizacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return StreamBuilder<ProgressoSincronismo>(
      stream: bibliaBloc.sincronizacao,
      builder: (context, snapshot) {
        return AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                IntlText(
                  "biblia.sincronizando",
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
                    valueColor: AlwaysStoppedAnimation(tema.primary),
                    backgroundColor: tema.primary.withOpacity(.5),
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
