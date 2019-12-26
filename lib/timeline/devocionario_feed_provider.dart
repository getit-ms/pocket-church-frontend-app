part of pocket_church.timeline;

class DevocionarioFeedProvider extends FeedProvider {
  DevocionarioApi _devocionarioApi = DevocionarioApi();

  DevocionarioFeedProvider()
      : super(funcionalidade: Funcionalidade.DEVOCIONARIO);

  @override
  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina) async {
    Pagina<DiaDevocionario> resultado = await _devocionarioApi.consulta(
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
    );

    return Pagina(
      resultados: (resultado.resultados ?? []).map(_mapFeed).toList(),
      hasProxima: resultado.hasProxima,
      pagina: resultado.pagina,
      totalPaginas: resultado.totalPaginas,
      totalResultados: resultado.totalResultados,
    );
  }

  Feed _mapFeed(DiaDevocionario devocionario) => Feed(
          id: devocionario.id,
          image: devocionario.thumbnail?.id,
          data: devocionario.data,
          titulo: configuracaoBloc.currentBundle.get(
            'timeline.titulo.devocionario',
            args: {
              'data': StringUtil.formatData(
                devocionario.data,
                pattern: 'dd MMM yyyy',
              ),
            },
          ),
          funcionalidade: Funcionalidade.DEVOCIONARIO,
          autoria: configuracaoBloc.currentConfig.nomeIgreja,
          descricao: configuracaoBloc.currentBundle.get(
            'timeline.descricao.devocionario',
            args: {
              'data': StringUtil.formatData(
                devocionario.data,
                pattern: 'dd MMM yyyy',
              ),
            },
          ),
          args: {
            'devocionario': devocionario.toJson(),
          });

  @override
  resolveAction(BuildContext context, Feed feed) {
    return () {
      NavigatorUtil.navigate(
        context,
        builder: (context) => GaleriaPDF(
          titulo:
              configuracaoBloc.currentBundle.get('devocionario.devocionario'),
          arquivo: DiaDevocionario.fromJson(feed.args['devocionario']).arquivo,
        ),
      );
    };
  }

  @override
  ImageProvider resolveImageProvider(Feed feed) {
    return ArquivoImageProvider(feed.image);
  }
}
