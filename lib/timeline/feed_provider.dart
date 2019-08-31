part of pocket_church.timeline;

const TAMANHO_PAGINA = 3;

abstract class FeedProvider {
  List<Feed> _cache = [];
  int _current = 0;
  bool _finished = false;
  Funcionalidade funcionalidade;

  FeedProvider({this.funcionalidade});

  Future<DateTime> currentDateTime() async {
    if (!acessoBloc.temAcesso(funcionalidade)) {
      return null;
    }

    if (!_finished && _current >= _cache.length) {
      await _nextPage();
    }

    if (_finished) {
      return null;
    }


    return _cache[_current].data;
  }

  _nextPage() async {
    if (!_finished) {
      int currentPage = (_cache.length / TAMANHO_PAGINA).ceil();

      Pagina<Feed> pagina = await busca(currentPage + 1, TAMANHO_PAGINA);

      _cache.addAll(pagina.resultados ?? []);

      _finished = !pagina.hasProxima;
    }
  }

  Feed next() {
    Feed current = _cache[_current];

    _current++;

    return current;
  }

  clear() {
    _finished = false;
    _cache.clear();
    _current = 0;
  }

  VoidCallback resolveAction(BuildContext context, Feed feed);

  ImageProvider resolveImageProvider(Feed feed);

  Future<Pagina<Feed>> busca(int pagina, int tamanhoPagina);
}