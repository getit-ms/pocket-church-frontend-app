part of pocket_church.inicio;

class PageInicio extends StatefulWidget {
  const PageInicio();

  @override
  _PageInicioState createState() => _PageInicioState();
}

class _PageInicioState extends State<PageInicio> with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    _tabController.dispose();
  }

  List<Widget> _silverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    Configuracao config = ConfiguracaoApp.of(context).config;

    return <Widget>[
      SliverAppBar(
        floating: true,
        snap: true,
        leading: IconUsuario(
        ),
        title: Text(config.nomeAplicativo),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              NavigatorUtil.navigate(
                context,
                builder: (context) => PageFiltro(),
              );
            },
          ),
          const IconNotificacoes(),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            if (_tabController.index == index) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          },
          tabs: [
            Tab(text: "Timeline"),
            Tab(text: "Calendário"),
            Tab(text: "Menu"),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomPlayerControl(safeArea: true),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: _silverBuilder,
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            TabTimeline(),
            TabCalendario(),
            TabMenu(),
          ],
        ),
      ),
    );
  }
}

