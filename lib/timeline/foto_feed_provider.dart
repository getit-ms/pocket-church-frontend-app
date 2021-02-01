part of pocket_church.timeline;

class FotoFeedProvider extends FeedProvider {
  FotoApi _fotoApi = FotoApi();

  FotoFeedProvider() : super(funcionalidade: Funcionalidade.GALERIA_FOTOS);

  @override
  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina) async {
    Pagina<GaleriaFotos> resultado = await _fotoApi.consultaGalerias(
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

  Feed _mapFeed(GaleriaFotos galeria) => Feed(
        id: galeria.id,
        image: galeria.fotoPrimaria.toJson(),
        data: galeria.dataAtualizacao,
        titulo: galeria.nome,
        funcionalidade: Funcionalidade.GALERIA_FOTOS,
        autoria: configuracaoBloc.currentConfig.nomeIgreja,
        descricao: galeria.descricao,
      );

  @override
  resolveAction(BuildContext context, Feed feed) {
    return () {
      NavigatorUtil.navigate(
        context,
        builder: (context) => PageListaFotos(
          galeria: GaleriaFotos(
            id: feed.id,
            nome: feed.titulo,
            descricao: feed.descricao,
            dataAtualizacao: feed.data,
            fotoPrimaria: Foto.fromJson(feed.image),
          ),
        ),
      );
    };
  }

  @override
  ImageProvider resolveImageProvider(Feed feed) {
    Foto foto = Foto.fromJson(feed.image);

    return NetworkImage(
        "https://farm${foto.farm}.staticflickr.com/${foto.server}/${foto.id}_${foto.secret}_n.jpg");
  }
}
