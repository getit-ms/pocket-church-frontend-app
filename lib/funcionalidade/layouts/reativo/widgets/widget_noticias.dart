part of pocket_church.widgets_reativos;


class WidgetNoticias extends StatelessWidget {

  const WidgetNoticias();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText("noticia.noticias",),
      onMore: (){
        NavigatorUtil.navigate(context,
            builder: (context) => PageListaNoticias()
        );
      },
      body: Container(
        height: 250,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          scrollDirection: Axis.horizontal,
          provider: (int pagina, int tamanhoPagina) async {
            return await noticiaApi.consulta(pagina: pagina, tamanhoPagina: tamanhoPagina);
          },
          builder: (context, itens, index) {
            Noticia noticia = itens[index];
            return new _ItemNoticiaWidget(noticia: noticia);
          },
          placeholderSize: 285,
          placeholderBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Container(
                height: 300,
                width: 275,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
            );
          },
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
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: RawMaterialButton(
        onPressed: (){
          NavigatorUtil.navigate(context,
              builder: (context) => PageNoticia(noticia: noticia)
          );
        },
        child: Container(
          height: 300,
          width: 275,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              const BoxShadow(
                  color: Colors.black54,
                  blurRadius: 2
              )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Hero(
              tag: 'noticia_' + noticia.id.toString(),
              child: Material(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: noticia.ilustracao != null ?
                              ArquivoImageProvider(noticia.ilustracao.id) :
                              tema.menuBackground,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            )
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white
                                  ]
                              )
                          ),
                          alignment: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                    Container(
                      height: 85,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 17,
                                  color: tema.primary,
                                  fontWeight: FontWeight.bold
                              ),
                              child: Text(noticia.titulo,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              )
                          ),
                          DefaultTextStyle(
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: 200,
                                    child: Text(noticia.autor.nome,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(StringUtil.formatData(noticia.dataPublicacao, pattern: 'dd MMM')),
                                ],
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

