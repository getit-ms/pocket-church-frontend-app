part of pocket_church.componentes;

typedef FilterCallback = Function(String text);

class PageTemplate extends StatefulWidget {
  final List<Widget> actions;
  final Widget body;
  final Widget title;
  final Color backgroundColor;
  final bool withAppBar;
  final bool deveEstarAutenticado;
  final FilterCallback onSearch;

  const PageTemplate({
    Key key,
    this.actions,
    this.body,
    this.title,
    this.onSearch,
    this.backgroundColor,
    this.withAppBar = true,
    this.deveEstarAutenticado = false,
  }) : super(key: key);

  @override
  PageTemplateState createState() => PageTemplateState();
}

class PageTemplateState extends State<PageTemplate> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  StreamSubscription<Membro> _subscriptionMembro;

  SearchBar _searchBar;

  OverlaySupportEntry _currentOverlay;

  ScaffoldState get scaffold => _scaffoldKey.currentState;

  bool _isRoot;

  @override
  void initState() {
    super.initState();

    messagingListener.addWhenNotificatoinOnTop(_onNotificationOnTop);

    this._subscriptionMembro = acessoBloc.membro.listen((membro) {
      if (widget.deveEstarAutenticado && membro == null) {
        Navigator.of(context).pop();
      }
    });

    _verificaFilterAppBar(context);
  }

  _onNotificationOnTop(AppNotification notification) {
    if (_currentOverlay != null) {
      _currentOverlay.dismiss();
    }

    _currentOverlay = showOverlayNotification(
      (context) => NotificacaoInterna(
        titulo: notification.title,
        mensagem: notification.message,
        onDismissed: () => _currentOverlay.dismiss(animate: false),
        action: () {
          if (_currentOverlay != null) {
            _currentOverlay.dismiss();
          }

          messagingListener.delegateOnResume(notification);
        },
      ),
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _subscriptionMembro.cancel();

    messagingListener.removeWhenNotificatoinOnTop(_onNotificationOnTop);
  }

  @override
  Widget build(BuildContext context) {
    if (_isRoot == null) {
      NavigatorState navigator = Navigator.of(context);
      _isRoot = !navigator.canPop();
    }

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return AnnotatedRegion<services.SystemUiOverlayStyle>(
      value: isDark ? services.SystemUiOverlayStyle.light : services.SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: widget.withAppBar
            ? (_searchBar != null
                ? _searchBar.build(context)
                : _defaultAppBar(context) as PreferredSizeWidget)
            : null,
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: <Widget>[
            Expanded(child: widget.body),
            const BottomPlayerControl(
              safeArea: true,
            )
          ],
        ),
        drawer: !_isRoot ? null : MenuDrawer(),
      ),
    );
  }

  AppBar _defaultAppBar(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return AppBar(
      automaticallyImplyLeading: true,
      title: widget.title,
      actions: widget.actions == null && _isRoot
          ? [IconUsuario(color: tema.appBarIcons)]
          : widget.actions,
    );
  }

  void _verificaFilterAppBar(BuildContext ctx) async {
    Bundle bundle = configuracaoBloc.currentBundle;

    if (widget.onSearch != null) {
      setState(() {
        _searchBar = new SearchBar(
          inBar: false,
          setState: setState,
          hintText: bundle['global.buscar'],
          onChanged: widget.onSearch,
          buildDefaultAppBar: (context) => AppBar(
            leading: !_isRoot
                ? null
                : IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
            title: widget.title,
            actions: [_searchBar.getSearchAction(context)],
          ),
        );
      });
    }
  }
}
