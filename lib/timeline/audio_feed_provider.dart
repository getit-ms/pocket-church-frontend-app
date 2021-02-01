part of pocket_church.timeline;

class AudioFeedProvider extends FeedProvider {
  AudioApi _audioApi = AudioApi();

  AudioFeedProvider() : super(funcionalidade: Funcionalidade.AUDIOS);

  @override
  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina) async {
    Pagina<Audio> resultado = await _audioApi.consulta(
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
    );

    return Pagina(
        resultados: (resultado.resultados ?? [])
            .map(_mapFeed)
            .toList(),
        hasProxima: resultado.hasProxima,
        pagina: resultado.pagina,
        totalPaginas: resultado.totalPaginas,
        totalResultados: resultado.totalResultados);
  }

  Feed _mapFeed(Audio audio) =>
      Feed(
        image: audio.capa?.id,
        data: audio.dataCadastro,
        titulo: audio.nome,
        funcionalidade: Funcionalidade.AUDIOS,
        autoria: audio.autor,
        descricao: audio.descricao,
        args: {
          'audio': audio.toJson()
        }
      );

  @override
  resolveAction(BuildContext context, Feed feed) {
    return () async {
      Audio audio = Audio.fromJson(feed.args['audio']);

      player.play(audio);
    };
  }

  @override
  ImageProvider resolveImageProvider(Feed feed) {
    return ArquivoImageProvider(feed.image);
  }
}
