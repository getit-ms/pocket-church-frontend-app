part of pocket_church.componentes;


class IconNotificacoes extends StatelessWidget {
  final Color color;
  final double size;

  const IconNotificacoes({
    Key key,
    this.size = 24,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    return IconButton(
      onPressed: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaNotificacoes(),
        );
      },
      iconSize: size,
      icon: StreamBuilder<Menu>(
          stream: acessoBloc.menu,
          builder: (context, snapshot) {
            int badgeCount = findBadgeCount(snapshot.data);

            return Badge(
              showBadge: badgeCount > 0,
              badgeColor: tema.badgeBackground,
              badgeContent: Text(
                badgeCount.toString(),
                style: TextStyle(color: tema.badgeText),
              ),
              child: Icon(
                Icons.notifications,
              ),
            );
          }),
    );
  }

  int findBadgeCount(Menu menu) {
    if (menu != null) {
      if ("Funcionalidade.${menu.funcionalidade}" ==
          Funcionalidade.NOTIFICACOES.toString()) {
        return menu.notificacoes ?? 0;
      }

      if (menu.submenus?.isNotEmpty ?? false) {
        for (Menu submenu in menu.submenus) {
          int count = findBadgeCount(submenu);

          if (count > 0) {
            return count;
          }
        }
      }
    }

    return 0;
  }
}
