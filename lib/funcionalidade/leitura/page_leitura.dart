part of pocket_church.leitura;

class PageLeitura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!leituraBloc.possuiPlano) {
      return PageListaPlanos().build(context);
    }

    return PageTemplate(
      deveEstarAutenticado: true,
      title: StreamBuilder<PlanoLeitura>(
          stream: leituraBloc.plano,
          builder: (context, snapshot) {
            return Text(snapshot.data?.descricao ?? "");
          }),
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
