part of pocket_church.funcionalidade_noticia;

class PageNoticia extends StatelessWidget {
  final Noticia noticia;

  const PageNoticia({@required this.noticia});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("noticia.noticia"),
      body: new _NoticiaContent(noticia: noticia),
    );
  }
}

class _NoticiaContent extends StatelessWidget {
  const _NoticiaContent({
    Key key,
    @required this.noticia,
  }) : super(key: key);

  final Noticia noticia;

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;
    var bundle = ConfiguracaoApp.of(context).bundle;

    return Hero(
      tag: 'noticia_' + noticia.id.toString(),
      child: Material(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      noticia.ilustracao == null
                          ? Container()
                          : InkWell(
                              onTap: () {
                                NavigatorUtil.navigate(context,
                                    builder: (context) => PhotoViewPage(
                                          images: [
                                            ImageView(
                                                image: ArquivoImageProvider(
                                                    noticia.ilustracao.id)),
                                          ],
                                          title: Text(noticia.titulo),
                                        ));
                              },
                              child: Stack(
                                children: <Widget>[
                                  Image(
                                    image: ArquivoImageProvider(
                                        noticia.ilustracao.id),
                                    width: double.infinity,
                                    height: 270,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black26,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Icon(
                                      Icons.zoom_in,
                                      size: 28,
                                    ),
                                    bottom: 10,
                                    right: 10,
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          noticia.titulo,
                          style: TextStyle(
                            color: tema.primary,
                            fontSize: 22,
                            height: 1.05,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder<Noticia>(
                              future: noticiaApi.detalha(noticia.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return Html(
                                  data: snapshot.data.texto,
                                  defaultTextStyle: TextStyle(
                                    height: 2,
                                    color: Colors.black54,
                                    fontSize: 17,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                  )
                ]),
                child: Row(
                  children: <Widget>[
                    Text(
                      StringUtil.formatDataLegivel(
                        noticia.dataPublicacao,
                        bundle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("|"),
                    const SizedBox(width: 5),
                    Text(noticia.autor.nome),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
