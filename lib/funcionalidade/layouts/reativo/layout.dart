part of pocket_church.layout_reativo;

class LayoutReativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Menu>(
        stream: acessoBloc.menu,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Menu> tabs = snapshot.data.submenus
                .where((mnu) =>
                    (mnu.submenus?.isNotEmpty ?? false) &&
                    "Funcionalidade.${mnu.funcionalidade}" !=
                        Funcionalidade.INICIO_APLICATIVO.toString())
                .toList();

            if (tabs.length > 3) {
              tabs = tabs.sublist(0, 3);
            }

            return _LayoutScaffold(
              tabs: tabs,
              menus: snapshot.data.submenus,
            );
          }

          return Container();
        });
  }
}

class _LayoutScaffold extends StatefulWidget {
  final List<Menu> tabs;
  final List<Menu> menus;

  const _LayoutScaffold({this.tabs, this.menus});

  @override
  _LayoutScaffoldState createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<_LayoutScaffold>
    with TickerProviderStateMixin {
  TabController _tabController;

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();

  int _activeIndex = 0;
  bool isAlerting = false;

  @override
  void initState() {
    super.initState();

    _prepareTabs();
  }

  _prepareTabs() {
    if (_tabController == null ||
        widget.tabs.length + 2 != _tabController.length) {
      _activeIndex = 0;
      _tabController = new TabController(
        length: widget.tabs.length + 2,
        vsync: this,
      );
    }
  }

  @override
  void didUpdateWidget(_LayoutScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    _prepareTabs();
  }

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;

    return WillPopScope(
      onWillPop: () async {
        if (isAlerting) {
          return true;
        }

        if (_tabController.index != 0) {
          _tabController.index = 0;
          return false;
        }

        MessageHandler.info(
          _scaffold.currentState,
          const IntlText("global.confirmacao_saida_app"),
          duration: const Duration(milliseconds: 1500),
        );

        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            isAlerting = false;
          });
        });

        setState(() {
          isAlerting = true;
        });

        return false;
      },
      child: Scaffold(
        key: _scaffold,
        backgroundColor: const Color(0xFFf7f7f7),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: _resolve(tabs: widget.tabs, menus: widget.menus),
              ),
            ),
            const BottomPlayerControl(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _activeIndex,
            selectedItemColor: tema.menuActiveIcon,
            unselectedItemColor: tema.menuIcon,
            elevation: 10,
            iconSize: 25,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _activeIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: SizedBox(
                  width: 30,
                  height: 25,
                  child: const Icon(
                    FontAwesomeIcons.home,
                  ),
                ),
                title: const IntlText(
                  "home.inicio",
                ),
              )
            ].followedBy(widget.tabs.map((menu) {
              return new BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Badge(
                  showBadge: (menu.notificacoes ?? 0) > 0,
                  badgeColor: tema.badgeBackground,
                  badgeContent: Text(
                    (menu.notificacoes ?? 0).toString(),
                    style: TextStyle(color: tema.badgeText),
                  ),
                  child: SizedBox(
                    width: 30,
                    height: 25,
                    child: Icon(
                      IconUtil.fromString(menu.icone),
                    ),
                  ),
                ),
                title: Text(
                  menu.nome,
                ),
              );
            })).followedBy([
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Badge(
                  showBadge:
                      widget.menus.any((menu) => (menu.notificacoes ?? 0) > 0),
                  badgeColor: tema.badgeBackground,
                  child: SizedBox(
                    width: 30,
                    height: 25,
                    child: const Icon(
                      FontAwesomeIcons.bars,
                    ),
                  ),
                ),
                title: const IntlText(
                  "global.menu.menu",
                ),
              )
            ]).toList()),
      ),
    );
  }

  Widget _resolve({
    List<Menu> tabs,
    List<Menu> menus,
  }) {
    if (_activeIndex == tabs.length + 1) {
      return new TabMais(
        menus: menus,
        onInicioPressed: () {
          setState(() {
            _activeIndex = 0;
          });
        },
      );
    }

    if (_activeIndex == 0) {
      return TabHome();
    }

    return TabMenu(
      menu: tabs[_activeIndex - 1],
    );
  }
}
