part of pocket_church.widgets_reativos;

class WidgetNoticias extends StatelessWidget {
  const WidgetNoticias();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText(
        "noticia.noticias",
      ),
      onMore: () {
        NavigatorUtil.navigate(context,
            builder: (context) => PageListaNoticias());
      },
      body: Container(
        height: 340,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          scrollDirection: Axis.horizontal,
          provider: (int pagina, int tamanhoPagina) async {
            return await noticiaApi.consulta(
                pagina: pagina, tamanhoPagina: tamanhoPagina);
          },
          builder: (context, itens, index) {
            Noticia noticia = itens[index];
            return new _ItemNoticiaWidget(noticia: noticia);
          },
          placeholderSize: 295,
          placeholderBuilder: (context) {
            return _placeholder();
          },
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        child: Container(
          width: 275,
        ),
      ),
    );
  }
}

class _ItemNoticiaWidget extends StatelessWidget {
  const _ItemNoticiaWidget({
    Key key,
    @required this.noticia,
  }) : super(key: key);

  final Noticia noticia;

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;

    return Padding(
      padding: const EdgeInsets.all(10),
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
          width: 275,
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
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      noticia.titulo,
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
