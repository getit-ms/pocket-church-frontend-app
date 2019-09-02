part of pocket_church.fotos;

class PageListaFotos extends StatelessWidget {
  final GaleriaFotos galeria;

  PageListaFotos({this.galeria});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      deveEstarAutenticado: true,
      withAppBar: false,
      body: Container(
        color: Colors.white,
        child: SliverInfiniteList<Foto>(
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
                            : Container())
                  ],
                ),
              );
            }

            return Container();
          },
          preSlivers: <Widget>[
            _header(),
            _descricao(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _header() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 350,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        title: Text(galeria.nome),
        background: Hero(
          tag: "galeria_" + galeria.id,
          child: Material(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://farm${galeria.fotoPrimaria.farm}.staticflickr.com/${galeria.fotoPrimaria.server}/${galeria.fotoPrimaria.id}_${galeria.fotoPrimaria.secret}_n.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1.3,
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
            image: NetworkImage(
                "https://farm${foto.farm}.staticflickr.com/${foto.server}/${foto.id}_${foto.secret}_n.jpg"),
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
          onDownload: Platform.isAndroid
              ? (index) {
                  arquivoService
                      .download(
                    "https://farm${foto.farm}.staticflickr.com/${foto.server}/${foto.id}_${foto.secret}_b.jpg",
                    "${foto.id}_${foto.secret}_b.jpg",
                  )
                      .then((file) {
                    MessageHandler.success(
                      Scaffold.of(context),
                      IntlText(
                        "mensagens.MSG-056",
                        args: {
                          'filename': file.substring(file.lastIndexOf("/") + 1),
                        },
                      ),
                    );
                  }).catchError((err) {
                    MessageHandler.error(
                      Scaffold.of(context),
                      const IntlText("mensagens.MSG-055"),
                    );
                  });
                }
              : null,
          onShare: (index) {
            arquivoService
                .downloadTemp(
              "https://farm${foto.farm}.staticflickr.com/${foto.server}/${foto.id}_${foto.secret}_b.jpg",
            )
                .then((file) async {
              final ByteData bytes = await services.rootBundle.load(file);
              Share.file(
                galeria.nome,
                "${foto.id}_${foto.secret}_b.jpg",
                bytes.buffer.asUint8List(),
                'image/jpeg',
              );
            }).catchError((err) {
              MessageHandler.error(
                Scaffold.of(context),
                const IntlText("mensagens.MSG-055"),
              );
            });
          },
          pageController: PageController(initialPage: index),
          images: itens
              .map((foto) => ImageView(
                  image: NetworkImage(
                      "https://farm${foto.farm}.staticflickr.com/${foto.server}/${foto.id}_${foto.secret}_b.jpg"),
                  heroTag: 'foto_' + foto.id))
              .toList(),
          title: Text(galeria.nome),
        ),
      );
    };
  }
}
