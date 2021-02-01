part of pocket_church.layout_reativo;

class TabMais extends StatefulWidget {
  final List<Menu> menus;
  final VoidCallback onInicioPressed;

  const TabMais({this.menus, this.onInicioPressed});

  @override
  _PageMaisState createState() => _PageMaisState();
}

class _PageMaisState extends State<TabMais> {
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;

    return Container(
      key: Key("tab_mais"),
      color: tema.buttonBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          _buildSearchBox(tema),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              Menu current = widget.menus[index];

              Widget submenus = _buildSubMenus(tema, current);

              if (submenus == null) {
                return Container();
              }

              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          IconUtil.fromString(current.icone),
                          color: tema.buttonText,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Badge(
                          showBadge: (current.notificacoes ?? 0) > 0,
                          badgeColor: tema.badgeBackground,
                          child: Text(
                            current.nome,
                            style: TextStyle(
                              color: tema.buttonText,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: submenus,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              );
            },
            childCount: widget.menus.length,
          ))
        ],
      ),
    );
  }

  Widget _buildSearchBox(Tema tema) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 76,
      titleSpacing: 1,
      backgroundColor: tema.buttonBackground.withOpacity(.75),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: tema.buttonBackground,
        ),
      ),
      title: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: IntlBuilder(
                    text: "global.buscar",
                    builder: (context, snapshot) {
                      return TextField(
                        controller: _searchController,
                        cursorColor: tema.buttonText,
                        style: TextStyle(color: tema.buttonText),
                        decoration: InputDecoration(
                            hintText: snapshot.data ?? "",
                            hintStyle: TextStyle(
                              color: tema.buttonText.withOpacity(.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: tema.buttonText.withOpacity(.5)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: tema.buttonText),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35))),
                            suffixIcon: Icon(
                              Icons.search,
                              color: tema.buttonText.withOpacity(.5),
                            )),
                      );
                    }),
              ),
            ),
            const IconNotificacoes(
              color: Colors.white,
            ),
            const IconUsuario(
              key: Key("icon_usuario"),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenus(Tema tema, Menu menu) {
    List<Menu> submenus = menu.submenus;

    if (submenus?.isEmpty ?? true) {
      submenus = [menu];
    }

    if (_searchController.text.isNotEmpty) {
      var filter = _searchController.text.toLowerCase();
      submenus = submenus.where((child) {
        return child.nome.toLowerCase().contains(filter);
      }).toList();

      if (submenus.isEmpty) {
        return null;
      }
    }

    List<Widget> col = [];
    List<Widget> row = [];

    for (Menu child in submenus) {
      if (row.length == 3) {
        col.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: row,
        ));
        row = [];
      }

      row.add(
        Expanded(
          child: RawMaterialButton(
            key: child.funcionalidade == 'INSTITUCIONAL' ? Key("opcao_institucional") : null,
            onPressed: () {
              _abreFuncionalidade(child.funcionalidade);
            },
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: <Widget>[
                Badge(
                  showBadge: (child.notificacoes ?? 0) > 0,
                  badgeColor: tema.badgeBackground,
                  badgeContent: Text(
                    (child.notificacoes ?? 0).toString(),
                    style: TextStyle(color: tema.badgeText),
                  ),
                  child: Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tema.buttonText,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text(
                      child.nome.substring(0, 1),
                      style:
                          TextStyle(color: tema.buttonBackground, fontSize: 35),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    child.nome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: tema.buttonText,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    while (row.length < 3) {
      row.add(Expanded(child: Container()));
    }

    col.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: row,
    ));

    return Column(
      children: col,
    );
  }

  void _abreFuncionalidade(String funcionalidade) {
    if ("Funcionalidade.$funcionalidade" ==
        Funcionalidade.INICIO_APLICATIVO.toString()) {
      if (widget.onInicioPressed != null) {
        widget.onInicioPressed();
      }

      return;
    }

    NavigatorUtil.navigate(
      context,
      builder: (context) => PageFactory.createPage(
        context,
        Funcionalidade.values.firstWhere(
            (func) => func.toString() == "Funcionalidade.$funcionalidade"),
      ),
    );
  }
}
