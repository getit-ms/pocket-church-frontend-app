part of pocket_church.componentes;

class MenuItemUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Membro>(
      stream: acessoBloc.membro,
      builder: (context, snapshot) {
        return AnimatedCrossFade(
          firstChild: Container(),
          secondChild: _itemUsuario(context, snapshot.data),
          crossFadeState: snapshot.hasData
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }

  _itemUsuario(BuildContext context, Membro membro) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return RawMaterialButton(
      elevation: 0,
      fillColor: tema.menuUserBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),
      onPressed: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PagePerfil(),
        );
      },
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FotoMembro(
              membro?.foto,
              color: Colors.white70,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Text(
            membro?.nome != null ? StringUtil.nomeResumido(membro.nome) : "",
            style: TextStyle(
              color: tema.menuUserText,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
