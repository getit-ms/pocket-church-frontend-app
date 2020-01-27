part of pocket_church.cantico;

class PageListaCanticos extends StatefulWidget {
  @override
  _PageListaCanticosState createState() => _PageListaCanticosState();
}

class _PageListaCanticosState extends State<PageListaCanticos> {
  String _filtro;

  Key _listKey = ValueKey("");
  Timer _searchTimer;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      title: const IntlText("cantico.canticos"),
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
      body: InfiniteList<Cantico>(
        key: _listKey,
        tamanhoPagina: 30,
        provider: (pagina, tamanhoPagina) async {
          return await canticoApi.consulta(
            filtro: _filtro,
            tipo: 'CANTICO',
            pagina: pagina,
            tamanhoPagina: tamanhoPagina,
          );
        },
        builder: (context, itens, index) {
          Cantico cantico = itens[index];

          return Material(
            color: Colors.white,
            child: ListTile(
              title: Text(
                cantico.titulo,
                style: TextStyle(
                  fontSize: 18,
                  color: tema.primary,
                ),
              ),
              subtitle: Text(cantico.autor ?? ""),
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _share(context, cantico),
              ),
              onTap: () {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => GaleriaPDF(
                    arquivo: cantico.cifra,
                    titulo: cantico.titulo,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  _share(BuildContext context, Cantico cantico) async {
    ShareUtil.shareArquivo(
      context,
      arquivo: cantico.cifra.id,
      filename: cantico.cifra.filename,
    );
  }
}
