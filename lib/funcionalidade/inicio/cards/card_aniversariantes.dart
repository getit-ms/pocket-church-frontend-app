part of pocket_church.inicio;

class CardAniversariantes extends StatelessWidget {
  CardAniversariantes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: acessoBloc.temAcesso(Funcionalidade.ANIVERSARIANTES),
      builder: (context, snapshot) {
        if (!snapshot.data) {
          return Container();
        }

        return StreamBuilder<List<Membro>>(
          stream: institucionalBloc.aniversariantes,
          initialData: institucionalBloc.currentAniversariantes,
          builder: (context, snapshot) {
            bool hasData = snapshot.data?.isNotEmpty ?? false;
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState:
              snapshot.connectionState == ConnectionState.waiting ||
                  hasData
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: _aniversariantes(context,
                  membros: hasData ? snapshot.data : [null, null, null]),
              secondChild: Container(),
            );
          },
        );
      },);
  }

  Widget _aniversariantes(BuildContext context, {List<Membro> membros}) {
    bool isDark = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: IntlText(
              "contato.aniversariantes_dia",
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var membro in membros)
                  ShimmerPlaceholder(
                    active: membro == null,
                    child: _aniversariante(context, membro: membro),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aniversariante(BuildContext context, {Membro membro}) {
    bool isDark = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark;

    return InkWell(
      onTap: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageContato(membro: membro),
        );
      },
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: FotoMembro(
                membro?.foto,
                size: 50,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            const SizedBox(height: 5),
            if (membro != null)
              Text(
                StringUtil.primeiroNome(membro.nome),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            if (membro == null)
              Container(
                height: 10,
                width: 180,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
