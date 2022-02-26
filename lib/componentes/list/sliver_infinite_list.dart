part of pocket_church.componentes;

class SliverInfiniteList<T> extends StatefulWidget {
  final FutureProvider<T> provider;
  final ItemBuilder<T> builder;
  final WidgetBuilder placeholderBuilder;
  final int placeholderCount;
  final double placeholderSize;
  final int tamanhoPagina;
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;
  final ListMerge<T> merger;
  final List<Widget> preSlivers;
  final List<Widget> posSlivers;
  final Future<List<T>> Function() cacheLoader;
  final Function(List<T>) cacheSaver;

  const SliverInfiniteList(
      {Key key,
      @required this.provider,
      @required this.builder,
      this.merger,
      this.preSlivers = const [],
      this.posSlivers = const [],
      this.placeholderBuilder,
      this.placeholderCount = 3,
      this.placeholderSize = 250,
      this.tamanhoPagina = 10,
      this.padding,
      this.cacheSaver,
      this.cacheLoader,
      this.scrollDirection = Axis.vertical})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SliverInfiniteListState<T>();
}

class SliverInfiniteListState<T> extends State<SliverInfiniteList<T>> {
  List<T> resultados = [];
  int pagina;
  bool hasProxima = true;

  bool _loading;
  Widget _error;
  IconData _errorIcon;

  @override
  void initState() {
    super.initState();

    _initAll();
  }

  _initAll() async {
    _reset();

    if (widget.cacheLoader != null) {
      List<T> cache = await widget.cacheLoader();

      if (_loading && resultados.isEmpty && cache != null) {
        setState(() {
          resultados.addAll(cache);
        });
      }
    }
  }

  refresh() async {
    await this._reset();
  }

  Future<void> _reset() async {
    pagina = 0;
    hasProxima = true;

    _loading = false;
    _error = null;

    return await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: _buildContent(context),
      onRefresh: _reset,
    );
  }

  Future<void> _loadMore() async {
    try {
      try {
        setState(() {
          _loading = true;
          _error = null;
          pagina++;
        });
      } catch (ex) {}

      Pagina<T> resultado = await widget.provider(pagina, widget.tamanhoPagina);

      setState(() {
        _loading = false;
        pagina = resultado.pagina;
        hasProxima = resultado?.hasProxima ?? false;

        if (pagina == 1) {
          resultados = [];
        }

        if (widget.merger != null) {
          resultados =
              widget.merger(resultados, resultado.resultados ?? []) ?? [];
        } else {
          resultados.addAll(resultado.resultados ?? []);
        }

        if (pagina == 1 && widget.cacheSaver != null) {
          widget.cacheSaver(resultados);
        }
      });
    } catch (ex) {
      print(ex);

      try {
        setState(() {
          _loading = false;
          _error = error.resolveMessage(ex);
          _errorIcon = error.resolveIcon(ex);
        });
      } catch (ex) {}
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (hasProxima) {
      if (_error != null) {
        return _buildError(context);
      } else if (!_loading) {
        _loadMore();
      }

      if (widget.placeholderBuilder != null) {
        return widget.placeholderBuilder(context);
      } else {
        return _buildLoading(context);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 20,
      ),
      alignment: Alignment.center,
      child: IntlText(
        "global.nenhum_registro_encontrado",
        textAlign: TextAlign.center,
      ),
    );
  }

  _buildContent(BuildContext context) {
    if (resultados.isEmpty) {
      return CustomScrollView(
        slivers: [
          ...widget.preSlivers,

          new SliverList(
            delegate: SliverChildListDelegate([_buildPlaceholder(context)]),
          ),

          ...widget.posSlivers,
        ],
      );
    } else {
      return CustomScrollView(
        slivers: [
          ...widget.preSlivers,

          new SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index == resultados.length) {
                  if (hasProxima) {
                    if (_error != null) {
                      return _buildError(context);
                    } else if (!_loading) {
                      _loadMore();
                    }

                    return _buildLoading(context);
                  } else {
                    return Container();
                  }
                } else if (index > resultados.length) {
                  return null;
                }

                return widget.builder(context, resultados, index);
              },
            ),
          ),

          ...widget.posSlivers,
        ],
      );
    }
  }

  Container _buildError(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(50),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            _errorIcon,
            color: isDark ? Colors.white38 : Colors.black38,
            size: 66,
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTextStyle(
            child: _error,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          RawMaterialButton(
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              side: BorderSide(
                color: isDark ? Colors.white54 : Colors.black54,
                width: .5,
              ),
            ),
            onPressed: refresh,
            child: const IntlText("global.tentar_novamente"),
          )
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    if (widget.placeholderBuilder != null) {
      List<Widget> children = [];

      for (int i = 0; i < widget.placeholderCount; i++) {
        children.add(
          ShimmerPlaceholder(
            active: true,
            child: widget.placeholderBuilder(context),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 20,
        ),
        width: widget.scrollDirection == Axis.horizontal
            ? widget.placeholderSize * widget.placeholderCount
            : double.infinity,
        height: widget.scrollDirection == Axis.vertical
            ? widget.placeholderSize * widget.placeholderCount
            : double.infinity,
        child: widget.scrollDirection == Axis.horizontal
            ? Row(
          children: children,
        )
            : Column(
          children: children,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 20,
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
