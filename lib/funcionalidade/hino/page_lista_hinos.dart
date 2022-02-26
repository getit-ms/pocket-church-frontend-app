part of pocket_church.hino;

class PageListaHinos extends StatefulWidget {
  @override
  _PageListaHinosState createState() => _PageListaHinosState();
}

class _PageListaHinosState extends State<PageListaHinos> {
  String _filtro;

  Key _listKey = ValueKey("");
  Timer _searchTimer;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      title: const IntlText("hino.hinos"),
      onSearch: (filtro) {
        if (_searchTimer != null) {
          _searchTimer.cancel();
        }

        this._searchTimer = Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _filtro = filtro;
            _listKey = ValueKey(filtro);
          });
        });
      },
      deveEstarAutenticado: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: InfiniteList<Hino>(
              key: _listKey,
              tamanhoPagina: 30,
              provider: (pagina, tamanhoPagina) async {
                return await hinoDAO.findHinosByFiltro(
                  filtro: _filtro,
                  pagina: pagina,
                  tamanhoPagina: tamanhoPagina,
                );
              },
              builder: (context, itens, index) {
                Hino hino = itens[index];

                return ListTile(
                  leading: Text(
                    hino.numero,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(hino.nome,
                    style: TextStyle(
                      fontSize: 18,
                      color: tema.primary,
                    ),
                  ),
                  onTap: () {
                    NavigatorUtil.navigate(
                      context,
                      builder: (context) => PageHino(
                        hino: hino,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          BarraProgressoSincronizacao(),
        ],
      ),
    );
  }
}
