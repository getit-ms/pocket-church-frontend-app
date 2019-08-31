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

  init() async {
    SharedPreferences sprefs = await SharedPreferences.getInstance();

    try {
      if (sprefs.containsKey(_chaveCache)) {
        List<Feed> cache = (json.decode(
            sprefs.getString(_chaveCache)) as List<dynamic>)
            .map((json) => Feed.fromJson(json))
            .toList();

        if (cache != null && cache.isNotEmpty) {
          Pagina<Feed> online = await busca(1, 1);

          if (online.resultados?.isNotEmpty??false) {
            if (!online.resultados[0].data.isAfter(cache[0].data)) {
              _cache = cache;
              return;
            }
          } else {
            sprefs.remove(_chaveCache);
            _finished = true;
          }
        }
      }
    } catch (ex) {
      print(ex);

      sprefs.remove(_chaveCache);
    }

    _nextPage();
  }

  String get _chaveCache => "cache_timeline_$funcionalidade";

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
      lista.add(await _fromIndex(index + i));
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

      if (next == null) {
        next = provider;
      } else {
        DateTime dataNext = await next.currentDateTime();

        if (data != null && dataNext.isBefore(data)) {
          next = provider;
        }
      }
    }

    if (next != null) {
      pool.add(next.next());
      return pool[index];
    }

    return null;
  }

  VoidCallback resolveAction(BuildContext context, Feed feed) {
    if (feed.image != null) {
      FeedProvider provider = providers.firstWhere((provider) => provider.funcionalidade == feed.funcionalidade);

      if (provider != null) {
        return provider.resolveAction(context, feed);
      }
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