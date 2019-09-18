part of pocket_church.cifra;

class PageListaCifras extends StatefulWidget {
  @override
  _PageListaCifrasState createState() => _PageListaCifrasState();
}

class _PageListaCifrasState extends State<PageListaCifras> {
  String _filtro;

  Key _listKey = ValueKey("");
  Timer _searchTimer;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      title: const IntlText("cifra.cifras"),
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
      deveEstarAutenticado: true,
      body: InfiniteList<Cantico>(
        key: _listKey,
        tamanhoPagina: 30,
        provider: (pagina, tamanhoPagina) async {
          return await canticoApi.consulta(
            filtro: _filtro,
            tipo: 'CIFRA',
            pagina: pagina,
            tamanhoPagina: tamanhoPagina,
          );
        },
        builder: (context, itens, index) {
          Cantico cifra = itens[index];

          return Material(
            color: Colors.white,
            child: ListTile(
              title: Text(
                cifra.titulo,
                style: TextStyle(
                  fontSize: 18,
                  color: tema.primary,
                ),
              ),
              subtitle: Text(cifra.autor ?? ""),
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _share(context, cifra),
              ),
              onTap: () {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => GaleriaPDF(
                    arquivo: cifra.cifra,
                    titulo: cifra.titulo,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  _share(BuildContext context, Cantico cifra) async {
    ShareUtil.shareArquivo(
      context,
      arquivo: cifra.cifra.id,
      filename: cifra.cifra.filename,
    );
  }
}
