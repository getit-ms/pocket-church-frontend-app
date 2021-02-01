part of pocket_church.timeline;

class NoticiaFeedProvider extends FeedProvider {
  NoticiaApi _noticiaApi = NoticiaApi();

  NoticiaFeedProvider() : super(funcionalidade: Funcionalidade.NOTICIAS);

  @override
  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina) async {
    Pagina<Noticia> resultado = await _noticiaApi.consulta(
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
    );

    return Pagina(
        resultados: (resultado.resultados ?? []).map(_mapFeed).toList(),
        hasProxima: resultado.hasProxima,
        pagina: resultado.pagina,
        totalPaginas: resultado.totalPaginas,
        totalResultados: resultado.totalResultados);
  }

  Feed _mapFeed(Noticia noticia) => Feed(
        id: noticia.id,
        image: noticia.ilustracao?.id,
        data: noticia.dataPublicacao,
        titulo: noticia.titulo,
        funcionalidade: Funcionalidade.NOTICIAS,
        autoria: noticia.autor.nome,
        descricao: noticia.resumo,
      );

  @override
  resolveAction(BuildContext context, Feed feed) {
    return () {
      NavigatorUtil.navigate(
        context,
        builder: (context) => PageNoticia(
          noticia: Noticia(
              id: feed.id,
              titulo: feed.titulo,
              autor: Membro(nome: feed.autoria),
              resumo: feed.descricao,
              dataPublicacao: feed.data,
              ilustracao: Arquivo(id: feed.image)),
        ),
      );
    };
  }

  @override
  ImageProvider resolveImageProvider(Feed feed) {
    return ArquivoImageProvider(feed.image);
  }
}
