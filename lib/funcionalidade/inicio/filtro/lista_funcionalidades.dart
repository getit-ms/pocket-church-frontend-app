part of pocket_church.inicio;

class ListaFuncionalidades extends StatelessWidget {
  final StatusFiltro status;
  final FiltroBloc bloc;

  const ListaFuncionalidades({Key key, this.status, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return StreamBuilder<List<Menu>>(
      stream: bloc.menus,
      initialData: [],
      builder: (context, snapshot) {
        List<Menu> menus =
            snapshot.data.isEmpty ? [null, null, null] : snapshot.data;
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              status == StatusFiltro.buscando || snapshot.data.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderFiltro(
                title: IntlText("filtro.funcionalidades"),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    return _ItemMenu(menu: menus[index]);
                  },
                  padding: const EdgeInsets.all(20),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 20);
                  },
                ),
              ),
            ],
          ),
          secondChild: Container(),
        );
      },
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final Menu menu;

  const _ItemMenu({Key key, this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
      return ShimmerPlaceholder(
        active: menu == null,
        child: _content(context),
      );
  }

  Widget _content(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: menu != null
          ? () {
              NavigatorUtil.navigate(
                context,
                builder: (context) => PageFactory.createPage(
                  context,
                  Funcionalidade.values.firstWhere(
                    (func) =>
                        func.toString() ==
                        "Funcionalidade.${menu.funcionalidade}",
                  ),
                ),
              );
            }
          : null,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: menu?.icone != null
                  ? Icon(
                      IconUtil.fromString(menu.icone),
                      color: tema.primary,
                    )
                  : Text(
                      menu?.nome?.substring(0, 1) ?? "",
                      style: TextStyle(
                        color: tema.primary,
                        fontSize: 24,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            if (menu != null)
              Text(
                menu.nome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black54,
                  fontSize: 12,
                ),
              ),
            if (menu == null)
              Container(
                height: 14,
                width: 80,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
