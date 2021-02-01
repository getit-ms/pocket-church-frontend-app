part of pocket_church.componentes;

class MenuDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: tema.menuBackground,
                  fit: BoxFit.cover,
                )
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 120,
                  maxWidth: 180,
                ),
                child: Image(
                  image: tema.menuLogo,
                ),
              ),
            ),
          ),
          MenuItemUsuario(),
          RaizMenu(),
        ],
      ),
    );
  }

}