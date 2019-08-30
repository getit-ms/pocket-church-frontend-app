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
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: noticia.ilustracao == null ? tema?.institucionalBackground : ArquivoImageProvider(noticia.ilustracao.id),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter
                                )
                            ),
                            child: Container(
                                height: 200,
                                decoration: const BoxDecoration(
                                    gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white12,
                                          Colors.white,
                                        ]
                                    )
                                ),
                                padding: EdgeInsets.all(20),
                                alignment: Alignment.bottomLeft,
                                child: Text(noticia.titulo,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: tema?.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
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
                                          fontSize: 15,
                                          letterSpacing: 1.03,
                                          height: 1.4
                                      ),
                                    );
                                  }
                                ),
                                const SizedBox(height: 20,),
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 8
                                        )
                                      ]
                                  ),
                                  child: noticia.ilustracao == null ? Container() : Image(
                                    image: ArquivoImageProvider(noticia.ilustracao.id),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                        )
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(noticia.autor.nome),
                      Text(StringUtil.formatData(noticia.dataPublicacao, pattern: "dd MMM yyyy"),),
                    ],
                  ),
                ),
              ],
            )
        ),
    );
  }
}