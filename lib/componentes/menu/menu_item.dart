part of pocket_church.componentes;

class MenuItem extends StatefulWidget {
  Menu menu;

  MenuItem(this.menu);

  @override
  State<StatefulWidget> createState() => MenuItemState();
}

class MenuItemState extends State<MenuItem>
    with TickerProviderStateMixin<MenuItem> {
  StreamSubscription<Menu> _activeMenuSubscription;

  bool isActivated = false;
  AnimationController _animationController;
  CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();

    _activeMenuSubscription = menuBloc.activeMenu.listen(null);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Interval(0, 1))
          ..addListener(() {
            setState(() {});
          });

    _activeMenuSubscription.onData((active) {
      if ((active == widget.menu) != isActivated) {
        this.isActivated = !this.isActivated;

        if (isActivated) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _activeMenuSubscription.cancel();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    if (isActivated || _animationController.isAnimating) {
      return Container(
        color: Colors.black.withAlpha((0x12 * _animation.value).toInt()),
        child: Column(children: <Widget>[
          _menuLine(tema),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            vsync: this,
            child: Container(
              color: Colors.black.withAlpha((0x12 * _animation.value).toInt()),
              height: _animationController.isAnimating
                  ? (50 * widget.menu.submenus.length) * _animation.value
                  : null,
              child: Column(
                children: widget.menu.submenus.map((m) => MenuItem(m)).toList(),
              ),
            ),
          ),
        ]),
      );
    }

    return _menuLine(tema);
  }

  Widget _menuLine(Tema tema) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _translateIcon(tema),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                widget.menu.nome,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.05,
                  wordSpacing: 2,
                ),
              ),
            ),
            const SizedBox(width: 20),
            _suffix(tema)
          ],
        ),
      ),
      onTap: () {
        if ((widget.menu.submenus?.length ?? 0) > 0) {
          if (isActivated) {
            menuBloc.deactivateMenu();
          } else {
            menuBloc.activateMenu(widget.menu);
          }
        } else if (widget.menu.link != null) {
          Navigator.of(context).pop();
          if (widget.menu.link == 'home') {
            NavigatorUtil.navigate(
              context,
              replace: true,
              builder: (context) {
                Configuracao config = ConfiguracaoApp.of(context).config;

                if (config.template == 'tradicional') {
                  return LayoutTradicional();
                } else if (config.template == 'reativo') {
                  return LayoutReativo();
                } else {
                  return PageApresentacao(
                    trocaTemplate: true,
                  );
                }
              },
            );
          } else {
            NavigatorUtil.navigate(
              context,
              replace: true,
              builder: (context) => PageFactory.createPage(
                context,
                Funcionalidade.values.firstWhere((func) =>
                    func.toString() ==
                    "Funcionalidade.${widget.menu.funcionalidade}"),
              ),
            );
          }
        }
      },
    );
  }

  Widget _suffix(Tema tema) {
    if ((widget.menu.notificacoes ?? 0) > 0) {
      return Badge(
        badgeColor: tema.badgeBackground,
        padding: const EdgeInsets.all(3),
        badgeContent: Text(
          widget.menu.notificacoes.toString(),
          style: TextStyle(
            color: tema.badgeText,
            fontSize: 11,
          ),
        ),
      );
    }

    if ((widget.menu.submenus?.length ?? 0) > 0) {
      return Transform.rotate(
        angle: (math.pi / 2.0) * _animation.value,
        child: Icon(
          Icons.chevron_right,
          color: Colors.black45,
        ),
      );
    }

    return Container();
  }

  Widget _translateIcon(Tema tema) {
    IconData icon = IconUtil.fromString(widget.menu.icone);

    if (icon != null) {
      return Icon(
        icon,
        color: Color.lerp(tema.menuIcon, tema.menuActiveIcon, _animation.value),
        size: 22,
      );
    }

    return Container(
      width: 42,
    );
  }
}
