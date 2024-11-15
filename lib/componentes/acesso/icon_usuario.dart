part of pocket_church.componentes;

class IconUsuario extends StatelessWidget {
  final Color color;
  final double size;

  const IconUsuario({
    Key key,
    this.color,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return StreamBuilder<Membro>(
      stream: acessoBloc.membro,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return IconButton(
            iconSize: size,
            onPressed: () {
              NavigatorUtil.navigate(context,
                  builder: (context) => PagePerfil());
            },
            icon: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              child: SizedBox(
                  width: size,
                  height: size,
                  child: FotoMembro(
                    snapshot.data.foto,
                    color: color,
                  )),
            ),
          );
        }

        return IconButton(
          iconSize: size,
          color: color,
          onPressed: () {
            NavigatorUtil.navigate(context, builder: (context) => PageLogin());
          },
          icon: Icon(
            Icons.person_outline,
          ),
        );
      },
    );
  }
}
