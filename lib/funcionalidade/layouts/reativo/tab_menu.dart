part of pocket_church.layout_reativo;

class TabMenu extends StatelessWidget {
  final Menu menu;

  const TabMenu({this.menu});

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);

    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: TabMenuHeader(
              menu: menu,
              minExtent: mediaQueryData.padding.top + 60,
              maxExtent: mediaQueryData.padding.top +
                  mediaQueryData.size.height * .45),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return WidgetFuncionalidade(
                funcionalidade: FuncionalidadeByName(
                  menu.submenus[index].funcionalidade,
                ),
              );
            },
            childCount: menu.submenus.length,
          ),
        )
      ],
    );
  }
}

class TabMenuHeader extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Menu menu;

  const TabMenuHeader({this.menu, this.minExtent, this.maxExtent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    var mediaQueryData = MediaQuery.of(context);

    double currentExtent = max(minExtent, maxExtent - shrinkOffset);
    double factor = min(
        1,
        (currentExtent - minExtent) /
            (min(minExtent + 120, maxExtent) - minExtent));

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: tema.menuBackground,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(tema.appBarBackground,
                          tema.buttonBackground.withOpacity(.75), factor),
                      Color.lerp(
                          tema.appBarBackground, Colors.transparent, factor)
                    ]),
                boxShadow: [
                  BoxShadow(
                      color: Color.lerp(
                          Colors.black54, Colors.transparent, factor),
                      blurRadius: 5 - 5 * factor)
                ]),
            child: Column(
              children: <Widget>[
                Container(
                  height: currentExtent - 50,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color.lerp(tema.appBarBackground,
                          const Color(0xFFEFEFEF), factor),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50 * factor),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(
                              tema.appBarBackground, Colors.black26, factor),
                          blurRadius: 5 * factor,
                          offset: const Offset(0, -5),
                        )
                      ]),
                )
              ],
            ),
          ),
          Positioned(
            top: mediaQueryData.padding.top + (currentExtent - 170) * factor,
            left: 30 * factor,
            child: Container(
              height: 60 + 60 * factor,
              width: 60 + 20 * factor,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.lerp(
                    Colors.transparent, tema.buttonBackground, factor),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Color.lerp(
                          Colors.transparent, Colors.black54, factor),
                      blurRadius: 5)
                ],
              ),
              child: Icon(
                IconUtil.fromString(menu.icone),
                size: 25 + 10 * factor,
                color: Color.lerp(tema.appBarIcons, tema.buttonText, factor),
              ),
            ),
          ),
          Positioned(
            top: mediaQueryData.padding.top +
                20 +
                (currentExtent - 145) * factor,
            left: 60 + 60 * factor,
            child: Text(
              menu.nome,
              style: TextStyle(
                color: Color.lerp(tema.appBarTitle, tema.buttonText, factor),
                fontSize: 18 + 12 * factor,
                shadows: [
                  Shadow(
                      color: Color.lerp(
                          Colors.transparent, Colors.black54, factor),
                      blurRadius: 10)
                ],
              ),
            ),
          ),
          Positioned(
            top: mediaQueryData.padding.top,
            width: mediaQueryData.size.width,
            height: 60 + 20 * factor,
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  /*IconButton(
                    onPressed: () {},
                    iconSize: 24 + 10 * factor,
                    icon: Icon(
                      Icons.search,
                      color:
                          Color.lerp(tema.appBarIcons, tema.buttonText, factor),
                    ),
                  ),
                  SizedBox(width: 20 * factor),*/
                  new IconNotificacoes(
                    size: 24 + 10 * factor,
                    color:
                        Color.lerp(tema.appBarIcons, tema.buttonText, factor),
                  ),
                  SizedBox(width: 20 * factor),
                  IconUsuario(
                    size: 24 + 10 * factor,
                    color:
                        Color.lerp(tema.appBarIcons, tema.buttonText, factor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
