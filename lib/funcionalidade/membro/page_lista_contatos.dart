part of pocket_church.membro;

class PageListaContatos extends StatefulWidget {
  @override
  _PageListaContatosState createState() => _PageListaContatosState();
}

class _PageListaContatosState extends State<PageListaContatos> {
  String _filtro;

  Key _listKey = ValueKey("");
  Timer _searchTimer;

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return PageTemplate(
      title: IntlText("contato.contatos"),
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
      body: InfiniteList<Membro>(
        key: _listKey,
        tamanhoPagina: 30,
        provider: (pagina, tamanhoPagina) async {
          return await membroApi.consulta(
            filtro: _filtro,
            pagina: pagina,
            tamanhoPagina: tamanhoPagina,
          );
        },
        builder: (context, itens, index) {
          Membro membro = itens[index];
          return Column(
            children: <Widget>[
              index == 0 ||
                      itens[index - 1].nome[0].toUpperCase() !=
                          membro.nome[0].toUpperCase()
                  ? InfoDivider(
                      child: Text(membro.nome[0]),
                    )
                  : Container(),
              ListTile(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: FotoMembro(
                    membro.foto,
                    size: 50,
                    color: isDark ? Colors.white54 : Colors.black12,
                  ),
                ),
                title: Text(membro.nome),
                subtitle: Text(membro.email ?? ""),
                onTap: () {
                  NavigatorUtil.navigate(
                    context,
                    builder: (context) => PageContato(
                      membro: membro,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
