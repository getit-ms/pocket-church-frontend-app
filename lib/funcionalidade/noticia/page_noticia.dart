part of pocket_church.funcionalidade_noticia;

class PageNoticia extends StatelessWidget {
  final Noticia noticia;

  const PageNoticia({@required this.noticia});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("noticia.noticia"),
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
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            noticia.titulo,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            StringUtil.formatData(noticia.dataPublicacao,
                                pattern: "dd MMMM yyyy HH:mm"),
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ilustracao(context),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(34),
                                child: FotoMembro(
                                  noticia.autor.foto,
                                  size: 34,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(noticia.autor.nome),
                                    Text(
                                      noticia.autor.email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<Noticia>(
                            future: noticiaApi.detalha(noticia.id),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return CustomHtml(
                                html: snapshot.data.texto,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _ilustracao(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PhotoViewPage(
            images: [
              ImageView(
                  image: ArquivoImageProvider(noticia.ilustracao.id),
                  heroTag: "ilustracao_${noticia.ilustracao.id}"),
            ],
            title: Text(noticia.titulo),
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Hero(
            tag: "ilustracao_${noticia.ilustracao.id}",
            child: Image(
              image: ArquivoImageProvider(noticia.ilustracao.id),
              width: double.infinity,
              height: 270,
              fit: BoxFit.cover,
            ),
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
    );
  }
}
