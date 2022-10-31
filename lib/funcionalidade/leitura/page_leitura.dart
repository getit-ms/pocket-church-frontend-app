part of pocket_church.leitura;

class PageLeitura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!leituraBloc.possuiPlano) {
      return PageTemplate(
        deveEstarAutenticado: true,
        title: IntlText("leitura.leitura_biblica"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntlText("leitura.nenhum_plano_ativo"),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => PageListaPlanos(),
                );
              },
              child: IntlText("leitura.selecionar_plano"),
            ),
          ],
        ),
      );
    }

    return PageTemplate(
      deveEstarAutenticado: true,
      title: StreamBuilder<PlanoLeitura>(
        stream: leituraBloc.plano,
        builder: (context, snapshot) {
          return Text(snapshot.data?.descricao ?? "");
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  BarraProgressoLeitura(),
                  CalendarioLeitura(),
                ],
              ),
            ),
          ),
          BarraProgressoSincronizacao(),
        ],
      ),
    );
  }
}
