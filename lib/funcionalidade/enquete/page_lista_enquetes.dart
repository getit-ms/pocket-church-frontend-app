part of pocket_church.enquete;

class PageListaEnquetes extends StatelessWidget {
  GlobalKey<InfiniteListState> _list = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("votacao.votacoes"),
      body: InfiniteList<Enquete>(
          key: _list, provider: _provider, builder: _builder),
    );
  }

  Future<Pagina<Enquete>> _provider(int pagina, int tamanhoPagina) async {
    return await enqueteApi.consulta(
        pagina: pagina, tamanhoPagina: tamanhoPagina);
  }

  Widget _builder(BuildContext context, List<Enquete> itens, int index) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    Enquete item = itens[index];

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.nome,
                        style: TextStyle(
                          color: tema.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        item.descricao,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                IntlText(
                  item.encerrado ? "votacao.encerrada" : "votacao.em_andamento",
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: ButtonEnquete(
                enquete: item,
                onRespondido: () {
                  _list.currentState.refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
