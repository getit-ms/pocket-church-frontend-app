part of pocket_church.funcionalidade_noticia;

class PageListaNoticias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("noticia.noticias"),
      body: InfiniteList(
        padding: const EdgeInsets.all(5),
        provider: (int pagina, int tamanhoPagina) async {
          return await noticiaApi.consulta(
              pagina: pagina, tamanhoPagina: tamanhoPagina);
        },
        builder: (context, itens, index) {
          return new _ItemNoticiaLista(
            noticia: itens[index],
          );
        },
      ),
    );
  }
}

class _ItemNoticiaLista extends StatelessWidget {
  final Noticia noticia;

  const _ItemNoticiaLista({
    Key key,
    this.noticia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: RawMaterialButton(
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageNoticia(
              noticia: noticia,
            ),
          );
        },
        fillColor: Colors.transparent,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  child: Hero(
                    tag: 'noticia_' + noticia.id.toString(),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: noticia.ilustracao != null
                          ? ArquivoImageProvider(noticia.ilustracao.id)
                          : tema.institucionalBackground,
                      width: double.infinity,
                      height: 270,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 65,
                      bottom: 15,
                      left: 15,
                      right: 15,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                noticia.titulo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: FotoMembro(
                                      noticia.autor.foto,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      noticia.autor.nome,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                StringUtil.formatData(noticia.dataPublicacao,
                                    pattern: 'dd'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                StringUtil.formatData(noticia.dataPublicacao,
                                        pattern: 'MMM yyyy')
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
