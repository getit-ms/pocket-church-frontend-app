part of pocket_church.funcionalidade_noticia;

class PageListaNoticias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("noticia.noticias"),
      body: InfiniteList(
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
    var bundle = ConfiguracaoApp.of(context).bundle;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: RawMaterialButton(
        fillColor: Colors.white,
        child: Hero(
          tag: 'noticia_' + noticia.id.toString(),
          child: Material(
            child: Column(
              children: <Widget>[
                noticia.ilustracao != null
                    ? FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: ArquivoImageProvider(noticia.ilustracao.id),
                        width: double.infinity,
                        height: 270,
                        fit: BoxFit.cover,
                      )
                    : Container(),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              noticia.titulo,
                              style: TextStyle(
                                color: tema.primary,
                                fontSize: 22,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              noticia.resumo?.trim() ?? "",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                height: 1.2,
                                letterSpacing: 1.05,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageNoticia(
              noticia: noticia,
            ),
          );
        },
      ),
    );
  }
}
