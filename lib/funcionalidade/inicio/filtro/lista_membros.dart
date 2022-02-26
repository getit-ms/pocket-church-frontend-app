part of pocket_church.inicio;

class ListaMembroes extends StatelessWidget {
  final StatusFiltro status;
  final FiltroBloc bloc;

  const ListaMembroes({Key key, this.status, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return StreamBuilder<List<Membro>>(
      stream: bloc.membros,
      initialData: [],
      builder: (context, snapshot) {
        List<Membro> membros =
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
                title: const IntlText(
                  "filtro.membros"
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  itemCount: membros.length,
                  itemBuilder: (context, index) {
                    return _ItemMembro(membro: membros[index]);
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

class _ItemMembro extends StatelessWidget {
  final Membro membro;

  const _ItemMembro({Key key, this.membro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return ShimmerPlaceholder(
        active: membro == null,
        child: _content(context),
      );
  }

  Widget _content(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: membro != null
          ? () {
              NavigatorUtil.navigate(
                context,
                builder: (context) => PageContato(
                  membro: membro,
                ),
              );
            }
          : null,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: FotoMembro(
                membro?.foto,
                size: 80,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            const SizedBox(height: 10),
            if (membro != null)
              Text(
                StringUtil.nomeResumido(membro.nome),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black54,
                  fontSize: 12,
                ),
              ),
            if (membro == null)
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
