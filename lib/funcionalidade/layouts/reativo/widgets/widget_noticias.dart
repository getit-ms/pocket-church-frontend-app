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
          placeholderSize: 340,
          placeholderBuilder: (context) {
            return _placeholder();
          },
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 180,
            width: 275,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 19,
            width: 275,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Container(
            width: 275,
            height: 16,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 275,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.black87,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 16,
                    width: 20,
                    color: Colors.white,
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.timer,
                    color: Colors.black87,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 16,
                    width: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
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

    return RawMaterialButton(
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      onPressed: () {
        NavigatorUtil.navigate(context,
            builder: (context) => PageNoticia(noticia: noticia));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCCCCCC),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Hero(
                tag: 'noticia_' + noticia.id.toString(),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: noticia.ilustracao != null
                      ? ArquivoImageProvider(noticia.ilustracao.id)
                      : tema.menuBackground,
                  fit: BoxFit.cover,
                  height: 180,
                  width: 275,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 275,
            child: Text(
              noticia.titulo,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: tema.primary,
                fontSize: 19,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 275,
            child: Text(
              noticia.resumo?.trim() ?? "",
              style: TextStyle(
                color: Colors.black38,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 275,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.black87,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(StringUtil.primeiroNome(noticia.autor.nome)),
                  Expanded(child: Container()),
                  Icon(
                    Icons.timer,
                    color: Colors.black87,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    StringUtil.formatData(
                          noticia.dataPublicacao,
                          pattern: "dd MMM HH",
                        ) +
                        "h",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
