part of pocket_church.inicio;

class TabMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Menu>>(
      initialData: [],
      stream: acessoBloc.menuOptions,
      builder: (context, snapshot) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20,
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              for (Menu menu in snapshot.data) _buildItemMenu(context, menu),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemMenu(BuildContext context, Menu menu) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SizedBox(
      width:
          math.max(150, math.min(180, MediaQuery.of(context).size.width * .4)),
      child: RawMaterialButton(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
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
                height: 20,
                width: double.infinity,
              ),
              Text(
                menu.nome,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(
                height: 5,
                width: double.infinity,
              ),
              Row(
                children: [
                  Icon(
                    IconUtil.fromString(menu.categoria.icone) ?? Icons.circle,
                    color: isDark ? Colors.white54 : Colors.black54,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    menu.categoria.nome,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
