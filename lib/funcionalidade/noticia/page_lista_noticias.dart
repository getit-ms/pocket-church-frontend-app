part of pocket_church.funcionalidade_noticia;

class PageListaNoticias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("noticia.noticias"),
      body: InfiniteList(
        padding: EdgeInsets.all(5),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: ElevatedButton(
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageNoticia(
              noticia: noticia,
            ),
          );
        },
        child: Container(
          height: 320,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: const Color(0xFFDEDEDE),
                  child: FadeInImage(
                    image: noticia.ilustracao != null
                        ? ArquivoImageProvider(noticia.ilustracao.id)
                        : tema.menuBackground,
                    placeholder: MemoryImage(kTransparentImage),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 145,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      noticia.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: tema.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Text(
                        noticia.resumo?.trim() ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          noticia.autor.nome,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                        Text(
                          StringUtil.formatDataLegivel(
                            noticia.dataPublicacao,
                            configuracaoBloc.currentBundle,
                            porHora: true,
                            pattern: 'dd MMM',
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
