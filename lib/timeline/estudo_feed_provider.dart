part of pocket_church.timeline;

class EstudoFeedProvider extends FeedProvider {
  EstudoApi _estudoApi = EstudoApi();

  EstudoFeedProvider() : super(funcionalidade: Funcionalidade.LISTAR_ESTUDOS);

  @override
  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina) async {
    Pagina<Estudo> resultado = await _estudoApi.consulta(
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

  Feed _mapFeed(Estudo estudo) => Feed(
        id: estudo.id,
        image: estudo.thumbnail?.id,
        data: estudo.data,
        titulo: estudo.titulo,
        funcionalidade: Funcionalidade.LISTAR_ESTUDOS,
        autoria: configuracaoBloc.currentConfig.nomeIgreja,
        descricao: configuracaoBloc.currentBundle.get(
          'timeline.descricao.estudo',
        ),
        args: {
          'estudo': estudo.toJson(),
        },
      );

  @override
  resolveAction(BuildContext context, Feed feed) {
    return () {
      NavigatorUtil.navigate(
        context,
        builder: (context) => PageEstudo(
          estudo: Estudo.fromJson(feed.args['estudo']),
        ),
      );
    };
  }

  @override
  ImageProvider resolveImageProvider(Feed feed) {
    return ArquivoImageProvider(feed.image);
  }
}
