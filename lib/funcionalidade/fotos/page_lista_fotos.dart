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
        child: FutureBuilder<Pagina<Foto>>(
            future: fotoApi.consulta(
              galeria: galeria.id,
              pagina: 1,
              tamanhoPagina: galeria.quantidadeFotos ?? 500,
            ),
            builder: (context, snapshot) {
              return CustomScrollView(
                slivers: <Widget>[
                  _header(),
                  _descricao(),
                  _fotos(context, snapshot),
                ],
              );
            }),
      ),
    );
  }

  _fotos(BuildContext context, AsyncSnapshot<Pagina<Foto>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData && snapshot.data.totalResultados > 0) {
        return SliverGrid(
          delegate: SliverChildListDelegate(
            snapshot.data.resultados
                .map((foto) => _linkFoto(
                    context: context,
                    foto: foto,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (ctx) => PhotoViewPage(
                          onDownload: Platform.isAndroid
                              ? (index) {
                                  Foto foto = snapshot.data.resultados[index];

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
                                          'filename': file.substring(
                                              file.lastIndexOf("/") + 1),
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
                            Foto foto = snapshot.data.resultados[index];

                            arquivoService
                                .downloadTemp(
                              "https://farm${foto.farm}.staticflickr.com/${foto.server}/${foto.id}_${foto.secret}_b.jpg",
                            )
                                .then((file) async {
                              final ByteData bytes =
                                  await services.rootBundle.load(file);
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
                          pageController: PageController(
                              initialPage:
                                  snapshot.data.resultados.indexOf(foto)),
                          images: snapshot.data.resultados
                              .map((foto) => ImageView(
                                  image: NetworkImage(
                                      "https://farm${foto.farm}.staticflickr.com/${foto.server}/${foto.id}_${foto.secret}_b.jpg"),
                                  heroTag: 'foto_' + foto.id))
                              .toList(),
                          title: Text(galeria.nome),
                        ),
                      );
                    }))
                .toList(),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
        );
      }

      return SliverList(
          delegate: SliverChildListDelegate(
        [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: IntlText("global.nenhum_registro_encontrado"),
            ),
          )
        ],
      ));
    }

    return SliverList(
        delegate: SliverChildListDelegate([
      Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: const CircularProgressIndicator(),
        ),
      )
    ]));
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
    return RawMaterialButton(
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
    );
  }
}
