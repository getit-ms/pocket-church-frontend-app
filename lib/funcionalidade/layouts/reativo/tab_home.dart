part of pocket_church.layout_reativo;

class TabHome extends StatefulWidget {
  @override
  _TabHomeState createState() => _TabHomeState();
}

final String CHAVE_CACHE_TIMELINE = "cache_timeline";

class _TabHomeState extends State<TabHome> {
  @override
  Widget build(BuildContext context) {
    return SliverInfiniteList<Feed>(
      preSlivers: <Widget>[
        SliverPersistentHeader(
          delegate: TabHomeHeader(
            minExtent: MediaQuery.of(context).padding.top + kToolbarHeight,
            maxExtent: 450,
          ),
          pinned: true,
        ),
        new SliverList(
          key: Key("sliver_list_home"),
          delegate: SliverChildListDelegate(
            [
              StreamBuilder<Institucional>(
                initialData: institucionalBloc.current,
                stream: institucionalBloc.institucional,
                builder: (context, snapshot) {
                  if (snapshot.data?.divulgacao != null) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        child: Image(
                          image: ArquivoImageProvider(
                            snapshot.data.divulgacao.id,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ],
      provider: _feedProvider,
      builder: _feedBuilder,
      cacheLoader: _loadCache,
      cacheSaver: _saveCache,
    );
  }

  Future<Pagina<Feed>> _feedProvider(int pagina, int tamanhoPagina) async {
    return await timelineProvider.consulta(pagina, tamanhoPagina);
  }

  Widget _feedBuilder(BuildContext context, List<Feed> itens, int index) {
    Feed feed = itens[index];

    return FeedItem(feed: feed);
  }

  Container fundo(tema) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: tema.homeBackground,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image(
                image: tema.homeLogo,
                height: 60,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<Institucional>(
              stream: institucionalBloc.institucional,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.divulgacao != null) {
                  return Image(
                    width: double.infinity,
                    image: ArquivoImageProvider(
                      snapshot.data.divulgacao.id,
                    ),
                    fit: BoxFit.cover,
                  );
                }

                return Container();
              },
            ),
          )
        ],
      ),
    );
  }

  Future<List<Feed>> _loadCache() async {
    SharedPreferences sprefs = await SharedPreferences.getInstance();

    if (sprefs.containsKey(CHAVE_CACHE_TIMELINE)) {
      return (json.decode(sprefs.get(CHAVE_CACHE_TIMELINE)) as List<dynamic>)
          .map((json) => Feed.fromJson(json))
          .toList();
    }

    return null;
  }

  _saveCache(List<Feed> feeds) async {
    SharedPreferences sprefs = await SharedPreferences.getInstance();

    sprefs.setString(CHAVE_CACHE_TIMELINE,
        json.encode(feeds.map((feed) => feed.toJson()).toList()));
  }
}

class TabHomeHeader extends SliverPersistentHeaderDelegate {
  final double maxExtent;
  final double minExtent;

  const TabHomeHeader({this.minExtent, this.maxExtent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    var queryData = MediaQuery.of(context);

    double currentExtent = max(minExtent, maxExtent - shrinkOffset);
    double factor = (currentExtent - minExtent) / (maxExtent - minExtent);
    double factor2 = max(
        0,
        min(
            1,
            (currentExtent - (maxExtent - 125)) /
                ((maxExtent - 50) - (maxExtent - 125))));
    double factor3 = max(
        0,
        min(
            1,
            (currentExtent - (minExtent + 50)) /
                ((minExtent + 150) - (minExtent + 50))));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.lerp(Colors.black87, Colors.transparent, factor),
            blurRadius: lerpDouble(3, 0, factor),
          )
        ],
        image: DecorationImage(
          image: tema.homeBackground,
          fit: BoxFit.cover,
          alignment: Alignment(0, lerpDouble(.5, 0, factor)),
        ),
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: _buildPrincipal(factor2, tema),
          ),
          _buildNovidades(queryData, factor3, tema),
          _buildIcons(queryData, factor),
          _buildLogo(queryData, factor, tema),
        ],
      ),
    );
  }

  Positioned _buildNovidades(
      MediaQueryData queryData, double factor3, Tema tema) {
    return Positioned(
      bottom: -25,
      left: queryData.size.width / 2 - 75,
      child: Opacity(
        opacity: lerpDouble(0, 1, factor3),
        child: SizedBox(
          width: 150,
          height: 50,
          child: RawMaterialButton(
            disabledElevation: 5,
            fillColor: tema.buttonBackground,
            textStyle: TextStyle(color: tema.buttonText),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.keyboard_arrow_up),
                const SizedBox(
                  width: 2,
                ),
                const IntlText("home.novidades"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildIcons(MediaQueryData queryData, double factor) {
    return Positioned(
      top: queryData.padding.top + 5,
      right: 10,
      child: Opacity(
        opacity: lerpDouble(1, 0, factor),
        child: Row(
          children: <Widget>[
            const IconNotificacoes(
              color: Colors.white,
            ),
            const IconUsuario(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildLogo(MediaQueryData queryData, double factor, Tema tema) {
    return Positioned(
      top: queryData.padding.top + lerpDouble(10, 15, factor),
      left: lerpDouble(10, queryData.size.width / 2 - 100, factor),
      child: Image(
        alignment: Alignment(lerpDouble(-1, 0, factor), 0),
        height: lerpDouble(minExtent - queryData.padding.top - 20, 80, factor),
        width: lerpDouble(150, 200, factor),
        image: tema.homeLogo,
      ),
    );
  }

  Opacity _buildPrincipal(double factor2, Tema tema) {
    return Opacity(
      opacity: lerpDouble(0, 1, factor2),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 35),
        child: StreamBuilder<Membro>(
          stream: acessoBloc.membro,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(150)),
                      child: FotoMembro(
                        snapshot.data.foto,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IntlText(
                      "home.bem_vindo_usuario",
                      textAlign: TextAlign.center,
                      args: {
                        'nome': StringUtil.primeiroNome(snapshot.data.nome)
                      },
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const IntlText("home.bem_vindo"),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        elevation: 8,
                        onPressed: () {
                          NavigatorUtil.navigate(
                            context,
                            builder: (context) => PageLogin(),
                          );
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        fillColor: tema.buttonText,
                        textStyle: TextStyle(color: tema.buttonBackground),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.lock_outline),
                            const SizedBox(
                              width: 2,
                            ),
                            const IntlText("home.acessar"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RawMaterialButton(
                        elevation: 8,
                        onPressed: () {
                          NavigatorUtil.navigate(
                            context,
                            builder: (context) => PageLogin(
                              cadastro: true,
                            ),
                          );
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        fillColor: tema.buttonText,
                        textStyle: TextStyle(color: tema.buttonBackground),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.add),
                            const SizedBox(
                              width: 2,
                            ),
                            const IntlText("home.cadastrar"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class FeedItem extends StatelessWidget {
  final Feed feed;

  const FeedItem({
    this.feed,
  });

  bool get compact =>
      feed.image == null || feed.funcionalidade == Funcionalidade.YOUTUBE;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      width: double.infinity,
      height: compact ? 200 : 350,
      child: ElevatedButton(
        onPressed: timelineProvider.resolveAction(context, feed),
        child: compact ? _compact(context, tema) : _expanded(context, tema),
      ),
    );
  }

  Widget _label() {
    switch (feed.funcionalidade) {
      case Funcionalidade.AUDIOS:
        return IntlText("timeline.label.audio");
      case Funcionalidade.YOUTUBE:
        return IntlText("timeline.label.youtube");
      case Funcionalidade.NOTICIAS:
        return IntlText("timeline.label.noticia");
      case Funcionalidade.LISTAR_ESTUDOS:
        return IntlText("timeline.label.estudo");
      case Funcionalidade.LISTAR_BOLETINS:
        return IntlText("timeline.label.boletim");
      case Funcionalidade.GALERIA_FOTOS:
        return IntlText("timeline.label.foto");
      default:
    }

    return Container();
  }

  Menu _menu() {
    for (Menu menu in acessoBloc.currentMenu.submenus) {
      if (IconUtil.fromString(menu.icone) != null) {
        if ("Funcionalidade.${menu.funcionalidade}" ==
            feed.funcionalidade.toString()) {
          return menu;
        }
      }

      if (menu.submenus != null) {
        for (Menu child in menu.submenus) {
          if ("Funcionalidade.${child.funcionalidade}" ==
              feed.funcionalidade.toString()) {
            if (IconUtil.fromString(child.icone) != null) {
              return child;
            }

            if (IconUtil.fromString(menu.icone) != null) {
              return menu;
            }
          }
        }
      }
    }

    return null;
  }

  Widget _compact(BuildContext context, Tema tema) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: _content(tema),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          tema.primary,
                          tema.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: timelineProvider.resolveImageProvider(feed) ??
                          tema.institucionalBackground,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _footer(context, tema)
      ],
    );
  }

  Widget _footer(BuildContext context, Tema tema) {
    Menu menu = _menu();

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black12,
            width: .5,
          ),
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 23,
              alignment: Alignment.centerLeft,
              child: Icon(
                IconUtil.fromString(menu.icone),
                color: Colors.black54,
                size: 14,
              ),
            ),
            Text(
              menu.nome,
            ),
            const Text(" | "),
            Text(
              StringUtil.formatDataLegivel(
                feed.data,
                configuracaoBloc.currentBundle,
                porHora: true,
                pattern: "dd MMM",
              ),
            ),
            Expanded(
              child: Container(),
            ),
            InkWell(
              onTap: () {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) =>
                      PageFactory.createPage(context, feed.funcionalidade),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: IntlText("global.mais"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(Tema tema) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            child: _label(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            feed.titulo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: tema.primary,
              fontSize: 19,
              height: .95,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            feed.descricao ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _expanded(BuildContext context, Tema tema) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    tema.primary,
                    tema.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: timelineProvider.resolveImageProvider(feed),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: _content(tema),
        ),
        _footer(context, tema),
      ],
    );
  }
}
