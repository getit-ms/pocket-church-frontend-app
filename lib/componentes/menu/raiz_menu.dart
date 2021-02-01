part of pocket_church.componentes;

class RaizMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Menu>(
      // ignore: undefined_identifier
      stream: acessoBloc.menu,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          return Column(
            children: snapshot.data.submenus
                .map((m) => MenuItem(m))
                .toList(),
          );
        }

        return Container();

      },
    );
  }

}