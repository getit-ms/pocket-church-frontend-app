part of pocket_church.timeline;

class VideoFeedProvider extends FeedProvider {
  VideoApi _videoApi = VideoApi();

  List<Video> _videos;

  VideoFeedProvider(): super(funcionalidade: Funcionalidade.YOUTUBE);

  @override
  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina) async {
    if (_videos == null) {
      _videos = (await _videoApi.consulta())
          .where((v) => v.agendamento == null)
          .toList();
    }

    int index = (pagina - 1) * tamanhoPagina;

    List<Video> videos = [];
    if (index < _videos.length) {
      videos.addAll(_videos.sublist(index,
          min(_videos.length, index + tamanhoPagina)),
      );
    }

    return Pagina(
        resultados: videos.map(_mapFeed).toList(),
        hasProxima: _videos.length > (index + tamanhoPagina),
        pagina: pagina,
        totalPaginas: (_videos.length / pagina).ceil(),
        totalResultados: _videos.length);
  }

  Feed _mapFeed(Video video) => Feed(
    id: video.id,
    image: video.thumbnail,
    data: video.publicacao,
    titulo: video.titulo,
    funcionalidade: Funcionalidade.YOUTUBE,
    autoria: configuracaoBloc.currentConfig.nomeIgreja,
    descricao: video.descricao,
  );

  @override
  resolveAction(BuildContext context, Feed feed) {
    return () {
      LaunchUtil.site("https://www.youtube.com/watch?v=${feed.id}");
    };
  }

  @override
  ImageProvider resolveImageProvider(Feed feed) {
    return NetworkImage(feed.image);
  }
}
