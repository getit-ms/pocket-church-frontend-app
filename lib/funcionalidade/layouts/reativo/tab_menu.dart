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
            maxExtent:
                mediaQueryData.padding.top + mediaQueryData.size.height * .45,
          ),
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
                  Color.lerp(Colors.transparent,
                      tema.buttonBackground.withOpacity(.75), factor),
                  Color.lerp(Colors.transparent, Colors.transparent, factor)
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.lerp(
                          tema.appBarBackground, Colors.transparent, factor),
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(
                              Colors.black54, Colors.transparent, factor),
                          blurRadius: lerpDouble(5, 0, factor),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: lerpDouble(0, 50, factor),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf7f7f7),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: lerpDouble(0, 20, factor),
            left: lerpDouble(0, 30, factor),
            child: Container(
              height: lerpDouble(
                  MediaQuery.of(context).padding.top + kToolbarHeight,
                  120,
                  factor),
              width: lerpDouble(60, 80, factor),
              padding: EdgeInsets.only(
                top: lerpDouble(
                    MediaQuery.of(context).padding.top + 10, 10, factor),
                left: 15,
                right: 15,
                bottom: 15,
              ),
              decoration: BoxDecoration(
                color: Color.lerp(
                    Colors.transparent, tema.buttonBackground, factor),
                borderRadius: BorderRadius.all(
                  Radius.circular(lerpDouble(0, 15, factor)),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Color.lerp(Colors.transparent, Colors.black54, factor),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Icon(
                IconUtil.fromString(menu.icone),
                size: lerpDouble(25, 35, factor),
                color: Color.lerp(tema.appBarIcons, tema.buttonText, factor),
              ),
            ),
          ),
          Positioned(
            bottom: lerpDouble(18.5, 70, factor),
            left: lerpDouble(60, 120, factor),
            child: Text(
              menu.nome,
              style: TextStyle(
                color: Color.lerp(tema.appBarTitle, tema.buttonText, factor),
                fontSize: 18 + 12 * factor,
                shadows: [
                  Shadow(
                    color:
                        Color.lerp(Colors.transparent, Colors.black54, factor),
                    blurRadius: 10,
                  )
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
