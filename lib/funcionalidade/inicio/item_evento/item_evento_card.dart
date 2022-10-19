part of pocket_church.inicio;

class ItemEventoCard extends StatelessWidget {
  final ItemEvento item;

  const ItemEventoCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return _outer(
      context,
      child: ShimmerPlaceholder(
        active: item == null,
        child: _inner(context),
      ),
      isDark: isDark,
    );
  }

  Widget _outer(BuildContext context, {Widget child, bool isDark}) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10) +
          (mediaQuery.size.width > 800
              ? EdgeInsets.symmetric(
                  horizontal: (mediaQuery.size.width * .2) / 2)
              : EdgeInsets.zero),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _inner(BuildContext context) {
    return Column(
      children: [
        _ItemEventoCardHeader(
          item: item,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: math.min(400, MediaQuery.of(context).size.width * .6),
          child: _ItemEventoCardBody(item: item),
        ),
        _ItemEventoCardBottom(
          item: item,
        ),
      ],
    );
  }
}

class _ItemEventoCardBody extends StatelessWidget {
  _ItemEventoCardBody({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ItemEvento item;

  final Map<TipoItemEvento, Function(ItemEvento item)> _bodyBuilders = {
    TipoItemEvento.AUDIO: (item) => BodyAudio(item: item),
    TipoItemEvento.BOLETIM: (item) => BodyBoletim(item: item),
    TipoItemEvento.PUBLICACAO: (item) => BodyBoletim(item: item),
    TipoItemEvento.ESTUDO: (item) => BodyEstudo(item: item),
    TipoItemEvento.EVENTO_INSCRICAO: (item) => BodyEventoInscricao(item: item),
    TipoItemEvento.EBD: (item) => BodyEventoInscricao(item: item),
    TipoItemEvento.CULTO: (item) => BodyEventoInscricao(item: item),
    TipoItemEvento.VIDEO: (item) => BodyVideo(item: item),
    TipoItemEvento.FOTOS: (item) => BodyFoto(item: item),
    TipoItemEvento.NOTICIA: (item) => BodyNoticia(item: item),
  };

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Container(
        color: Colors.white,
        width: double.infinity,
      );
    }

    Tema tema = ConfiguracaoApp.of(context).tema;

    var builder = _bodyBuilders[item.tipo];

    if (builder != null) {
      return builder(item);
    }

    return Center(
      child: Text(
        item.titulo,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: tema.primary,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _ItemEventoCardBottom extends StatelessWidget {
  const _ItemEventoCardBottom({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ItemEvento item;

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return StreamBuilder<Membro>(
        initialData: acessoBloc.currentMembro,
        stream: acessoBloc.membro,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              color: item == null
                  ? Colors.transparent
                  : isDark
                      ? Colors.grey[900]
                      : Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 3,
                ),
              ],
            ),
            child: IconTheme(
              data: IconThemeData(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (snapshot.data != null)
                        AcaoToggleLike(
                          item: item,
                        ),
                      if (snapshot.data != null)
                        AcaoItemEvento(
                          count: item?.quantidadeComentarios ?? 0,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => CommentPage(
                                itemEvento: item,
                              ),
                            );
                          },
                          icon: FontAwesomeIcons.comment,
                        ),
                      Expanded(
                        child: const SizedBox(height: 50),
                      ),
                      // TODO criar lógica para compartilhar itens
                      // AcaoItemEvento(
                      //   onPressed: () {},
                      //   icon: Icons.share,
                      //   text: "item_evento.compartilhar",
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _ItemEventoCardHeader extends StatelessWidget {
  const _ItemEventoCardHeader({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ItemEvento item;

  _detailAutor(BuildContext context) {
    if (item == null) {
      return null;
    }

    if (item.autor == null) {
      return () => NavigatorUtil.navigate(
            context,
            builder: (context) => PageInstitucional(),
          );
    }

    return () => NavigatorUtil.navigate(
          context,
          builder: (context) => PageContato(
            membro: item.autor,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Tema tema = ConfiguracaoApp.of(context).tema;
    Configuracao config = ConfiguracaoApp.of(context).config;
    Bundle bundle = ConfiguracaoApp.of(context).bundle;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: InkWell(
              onTap: _detailAutor(context),
              child: FotoMembro(
                item?.autor != null ? item.autor.foto : null,
                placeholder: item?.autor != null
                    ? const AssetImage("assets/imgs/avatar.png")
                    : tema.menuLogo,
                color: tema.primary,
                foreground: item?.autor == null ? Colors.white : Colors.black26,
                size: 35,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item == null)
                  Container(
                    color: Colors.white,
                    width: 180,
                    height: 18,
                  ),
                if (item != null)
                  InkWell(
                    onTap: _detailAutor(context),
                    child: Text(
                      item.autor?.nome ?? config.nomeIgreja,
                      style: TextStyle(
                        fontSize: 18,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                if (item == null)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    color: Colors.white,
                    width: 280,
                    height: 8,
                  ),
                if (item != null)
                  IntlText(
                    "timeline.subtitle." +
                        item.tipo.toString().replaceAll("TipoItemEvento.", ""),
                    args: {
                      'data': StringUtil.formatDataLegivelTimeline(
                          item.dataHoraPublicacao, bundle)
                    },
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // TODO implementar lógicas para listar mais
          // PopupMenuButton<VoidCallback>(
          //   child: Icon(
          //     Icons.more_vert,
          //     color: isDark ? Colors.white54 : Colors.black54,
          //   ),
          //   enabled: item != null,
          //   onSelected: (callback) {
          //     callback();
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return [
          //       PopupMenuItem(
          //         value: () {},
          //         child: Text("Mais itens desse tipo"),
          //       ),
          //       PopupMenuItem(
          //         value: () {},
          //         child: Text("Mais itens desse autor"),
          //       ),
          //     ];
          //   },
          // ),
        ],
      ),
    );
  }
}
