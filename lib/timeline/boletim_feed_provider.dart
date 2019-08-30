part of pocket_church.timeline;

class BoletimFeedProvider extends FeedProvider {
  BoletimApi _boletimApi = BoletimApi();

  BoletimFeedProvider() : super(funcionalidade: Funcionalidade.LISTAR_BOLETINS);

  @override
  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina) async {
    Pagina<Boletim> resultado = await _boletimApi.consulta(
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

  Feed _mapFeed(Boletim boletim) => Feed(
          id: boletim.id,
          image: boletim.thumbnail.id,
          data: boletim.dataPublicacao,
          titulo: boletim.titulo,
          funcionalidade: Funcionalidade.LISTAR_BOLETINS,
          autoria: configuracaoBloc.currentConfig.nomeIgreja,
          descricao: configuracaoBloc.currentBundle.get(
            'timeline.descricao.boletim',
            args: {
              'data': StringUtil.formatData(
                boletim.data,
                pattern: 'dd MMM yyyy',
              ),
            },
          ),
          args: {
            'boletim': boletim.toJson(),
          });

  @override
  resolveAction(BuildContext context, Feed feed) {
    return () {
      NavigatorUtil.navigate(
        context,
        builder: (context) => PageBoletim(
          boletim: Boletim.fromJson(feed.args['boletim']),
        ),
      );
    };
  }

  @override
  ImageProvider resolveImageProvider(Feed feed) {
    return ArquivoImageProvider(feed.image);
  }
}
