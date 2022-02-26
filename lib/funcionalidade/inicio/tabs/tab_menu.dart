part of pocket_church.inicio;

class TabMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Menu>(
      stream: acessoBloc.menu,
      builder: (context, snapshot) {
        List<Menu> menus = [];

        snapshot.data?.submenus
            ?.where((child) => child.funcionalidade != 'INICIO_APLICATIVO')
            ?.forEach(
          (child) {
            if (child.link != null) {
              menus.add(child);
            }

            if (child.submenus != null) {
              child.submenus
                  .where((sbm) => child.funcionalidade != 'INICIO_APLICATIVO')
                  .forEach(
                (sbm) {
                  if (sbm.link != null) {
                    menus.add(sbm);
                  }
                },
              );
            }
          },
        );

        return GridView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          itemBuilder: (context, index) {
            return _buildItemMenu(context, menus[index]);
          },
          itemCount: menus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
        );
      },
    );
  }

  Widget _buildItemMenu(BuildContext context, Menu menu) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return RawMaterialButton(
      onPressed: () {
        _abreFuncionalidade(context, menu.funcionalidade);
      },
      fillColor: isDark ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Badge(
        showBadge: (menu.notificacoes ?? 0) > 0,
        badgeColor: tema.badgeBackground,
        badgeContent: Text(
          (menu.notificacoes ?? 0).toString(),
          style: TextStyle(color: tema.badgeText),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconUtil.fromString(menu.icone) != null
                ? Icon(
                    IconUtil.fromString(menu.icone),
                    color: tema.buttonBackground,
                    size: 42,
                  )
                : Container(
                    height: 42,
                    width: 42,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: tema.primary,
                      shape: CircleBorder(),
                    ),
                    child: Text(
                      menu.nome.substring(0, 1),
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Text(
              _cammelCase(menu.nome),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _cammelCase(String text) {
    return text
        .split(" ")
        .map((palavra) =>
            palavra.substring(0, 1).toUpperCase() +
            palavra.substring(1).toLowerCase())
        .join(" ");
  }

  void _abreFuncionalidade(BuildContext context, String funcionalidade) {
    NavigatorUtil.navigate(
      context,
      builder: (context) => PageFactory.createPage(
        context,
        Funcionalidade.values.firstWhere(
            (func) => func.toString() == "Funcionalidade.$funcionalidade"),
      ),
    );
  }
}
