part of pocket_church.timeline;

class TimelineProvider {
  List<FeedProvider> providers = [
    BoletimFeedProvider(),
    NoticiaFeedProvider(),
    VideoFeedProvider(),
    FotoFeedProvider(),
    AudioFeedProvider(),
    EstudoFeedProvider(),
  ];

  List<Feed> pool = [];

  Future<Pagina<Feed>> consulta(int pagina, int tamanhoPagina) async {
    if (pagina == 1) {
      pool.clear();

      providers.forEach((provider) => provider.clear());
    }

    List<Feed> resultados = await _buildLista(pagina, tamanhoPagina);
    bool hasProxima = await _hasProxima(pagina, tamanhoPagina);

    return Pagina(
      pagina: pagina,
      totalResultados: pagina * tamanhoPagina + (hasProxima ? 1 : 0),
      hasProxima: hasProxima,
      resultados: resultados,
      totalPaginas: pagina + (hasProxima ? 1 : 0),
    );
  }

  Future<bool> _hasProxima(int pagina, int tamanhoPagina) async {
    var index = _index(pagina + 1, tamanhoPagina);

    Feed feed = await _fromIndex(index);

    return feed != null;
  }

  Future<List<Feed>>_buildLista(int pagina, int tamanhoPagina) async {
    var index = _index(pagina, tamanhoPagina);

    List<Feed> lista = [];

    for (int i=0;i<tamanhoPagina;i++) {
      var item = await _fromIndex(index + i);

      if (item != null) {
        lista.add(item);
      } else {
        break;
      }
    }

    return lista;
  }

  Future<Feed> _fromIndex(int index) async {
    if (pool.length > index) {
      return pool[index];
    }

    FeedProvider next;
    for (FeedProvider provider in providers) {
      DateTime data = await provider.currentDateTime();

      if (data != null && (next == null || (await next.currentDateTime()).isBefore(data))) {
        next = provider;
      }
    }

    if (next != null) {
      pool.add(next.next());
      return pool[index];
    }

    return null;
  }

  VoidCallback resolveAction(BuildContext context, Feed feed) {
    FeedProvider provider = providers.firstWhere((provider) => provider.funcionalidade == feed.funcionalidade);

    if (provider != null) {
      return provider.resolveAction(context, feed);
    }

    return null;
  }

  ImageProvider resolveImageProvider(Feed feed) {
    if (feed.image != null) {
      FeedProvider provider = providers.firstWhere((provider) => provider.funcionalidade == feed.funcionalidade);

      if (provider != null) {
        return provider.resolveImageProvider(feed);
      }
    }

    return null;
  }

  int _index(int pagina, int tamanhoPagina) {
    return (pagina - 1) * tamanhoPagina;
  }
}

TimelineProvider timelineProvider = new TimelineProvider();