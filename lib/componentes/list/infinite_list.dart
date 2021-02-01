part of pocket_church.componentes;

typedef FutureProvider<G> = Future<Pagina<G>> Function(
    int pagina, int tamanhoPagina);
typedef ItemBuilder<G> = Widget Function(
    BuildContext context, List<G> itens, int index);
typedef ListMerge<G> = List<G> Function(List<G> oldData, List<G> newData);

class InfiniteList<T> extends StatefulWidget {
  final FutureProvider<T> provider;
  final ItemBuilder<T> builder;
  final WidgetBuilder placeholderBuilder;
  final int placeholderCount;
  final double placeholderSize;
  final int tamanhoPagina;
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;
  final ListMerge<T> merger;

  const InfiniteList({
    Key key,
    @required this.provider,
    @required this.builder,
    this.merger,
    this.placeholderBuilder,
    this.placeholderCount = 3,
    this.placeholderSize = 250,
    this.tamanhoPagina = 10,
    this.padding,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => InfiniteListState<T>();
}

class InfiniteListState<T> extends State<InfiniteList<T>> {
  ScrollController controller;

  List<T> resultados = [];
  int pagina;
  bool hasProxima = true;

  bool _loading;
  Widget _error;
  IconData _errorIcon;

  var scrollControllerListener;

  @override
  void initState() {
    super.initState();

    _reset();

    controller = new ScrollController();

    scrollControllerListener = () {
      if (hasProxima && !_loading) {
        if (widget.placeholderBuilder != null) {
          if (controller.position.pixels >=
              controller.position.maxScrollExtent -
                  (widget.placeholderCount * widget.placeholderSize)) {
            _loadMore();
          }
        } else if (controller.position.pixels ==
            controller.position.maxScrollExtent) {
          _loadMore();
        }
      }
    };

    controller.addListener(scrollControllerListener);
  }

  @override
  void dispose() {
    super.dispose();

    controller.removeListener(scrollControllerListener);

    controller.dispose();
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
      });

      if (pagina == 1) {
        controller.animateTo(0,
            duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
      }
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

  _buildContent(BuildContext context) {
    if (resultados.isEmpty) {
      if (hasProxima) {
        if (_error != null) {
          return _buildError();
        } else if (!_loading) {
          _loadMore();
        }

        if (widget.placeholderBuilder != null) {
          return ListView(
            scrollDirection: widget.scrollDirection,
            padding: widget.padding,
            children: <Widget>[_buildLoading(context)],
          );
        } else {
          return _buildLoading(context);
        }
      }

      return Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: IntlText(
            "global.nenhum_registro_encontrado",
            textAlign: TextAlign.center,
          ));
    } else {
      return ListView.builder(
          controller: controller,
          padding: widget.padding,
          scrollDirection: widget.scrollDirection,
          itemCount: resultados.length + 1,
          itemBuilder: (context, index) {
            if (index == resultados.length) {
              if (hasProxima) {
                if (_error != null) {
                  return _buildError();
                } else if (!_loading) {
                  _loadMore();
                }

                return _buildLoading(context);
              } else {
                return Container();
              }
            }

            return widget.builder(context, resultados, index);
          });
    }
  }

  Container _buildError() {
    return Container(
      padding: EdgeInsets.all(50),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            _errorIcon,
            color: Colors.black38,
            size: 66,
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTextStyle(
            child: _error,
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          RawMaterialButton(
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              side: const BorderSide(
                color: Colors.black54,
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
          Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: widget.placeholderBuilder(context),
          ),
        );
      }

      return SizedBox(
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
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: const CircularProgressIndicator());
  }
}
