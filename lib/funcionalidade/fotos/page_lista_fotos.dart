part of pocket_church.fotos;

class PageListaFotos extends StatelessWidget {
  final GaleriaFotos galeria;

  PageListaFotos({this.galeria});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      deveEstarAutenticado: true,
      withAppBar: false,
      body: SliverInfiniteList<Foto>(
        provider: (pagina, tamanho) async {
          return await fotoApi.consulta(
            galeria: galeria.id,
            pagina: pagina,
            tamanhoPagina: tamanho,
          );
        },
        builder: (context, itens, index) {
          Foto foto = itens[index];

          if (index % 3 == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _linkFoto(
                      context: context,
                      foto: foto,
                      onPressed: onClick(context, itens, index),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: index + 1 < itens.length
                        ? _linkFoto(
                            context: context,
                            foto: itens[index + 1],
                            onPressed: onClick(context, itens, index + 1),
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: index + 2 < itens.length
                        ? _linkFoto(
                            context: context,
                            foto: itens[index + 2],
                            onPressed: onClick(context, itens, index + 2),
                          )
                        : Container(),
                  )
                ],
              ),
            );
          }

          return Container();
        },
        preSlivers: <Widget>[
          _header(context),
          _descricao(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: HeaderFotos(
        minExtent: MediaQuery.of(context).padding.top + kToolbarHeight,
        maxExtent: MediaQuery.of(context).padding.top + 350,
        background: Hero(
          tag: "galeria_" + galeria.id,
          child: Image(
            image: NetworkImage(galeria.fotoPrimaria.urlImagemNormal),
            fit: BoxFit.cover,
          ),
        ),
        title: Text(galeria.nome),
      ),
    );
  }

  SliverList _descricao() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              galeria.descricao ?? "",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _linkFoto({BuildContext context, Foto foto, VoidCallback onPressed}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 3 - 20,
      width: double.infinity,
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Hero(
          tag: 'foto_' + foto.id,
          child: FadeInImage(
            width: double.infinity,
            height: double.infinity,
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(foto.urlImagemNormal),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  onClick(BuildContext context, List<Foto> itens, int index) {
    Foto foto = itens[index];

    return () {
      showCupertinoModalPopup(
        context: context,
        builder: (ctx) => PhotoViewPage(
          onShare: (index) {
            ShareUtil.shareDownloadedFile(
              context,
              url: foto.urlImagemGrande,
              filename: "${foto.id}_${foto.secret}_b.jpg",
            );
          },
          pageController: PageController(initialPage: index),
          images: itens
              .map((foto) => ImageView(
                  image: NetworkImage(foto.urlImagemGrande),
                  heroTag: 'foto_' + foto.id))
              .toList(),
          title: Text(galeria.nome),
        ),
      );
    };
  }
}

class HeaderFotos extends SliverPersistentHeaderDelegate {
  final List<Widget> actions;
  final Widget title;
  final double minExtent;
  final double maxExtent;
  final Widget background;

  const HeaderFotos({
    this.title,
    this.background,
    this.actions,
    this.minExtent,
    this.maxExtent,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var mediaQueryData = MediaQuery.of(context);

    double currentExtent = max(minExtent, maxExtent - shrinkOffset);
    double factor = min(
        1,
        (currentExtent - minExtent) /
            (min(minExtent + 120, maxExtent) - minExtent));

    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: lerpDouble(3, 0, factor),
                    color: Colors.black54,
                  ),
                ],
              ),
              child: background ?? Container(),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.lerp(Theme.of(context).appBarTheme.color,
                        Colors.transparent, factor),
                    Color.lerp(Theme.of(context).appBarTheme.color,
                        Colors.black54, factor),
                  ],
                  radius: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: mediaQueryData.padding.top + 3,
            left: 5,
            child: BackButton(
              color: Color.lerp(
                Theme.of(context).appBarTheme.iconTheme.color,
                Colors.white,
                factor,
              ),
            ),
          ),
          Positioned(
            bottom: lerpDouble(5, 15, factor),
            left: lerpDouble(33, 3, factor),
            width: lerpDouble(
              mediaQueryData.size.width - 66,
              mediaQueryData.size.width - 6,
              factor,
            ),
            height: lerpDouble(kToolbarHeight - 10, 100, factor),
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: lerpDouble(21, 32, factor),
                color: Color.lerp(
                  Theme.of(context).appBarTheme.textTheme.headline6.color,
                  Colors.white,
                  factor,
                ),
              ),
              child: title ?? Container(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
