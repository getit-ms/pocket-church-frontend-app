part of pocket_church.inicio;

class ListaItensEvento extends StatelessWidget {
  final StatusFiltro status;
  final FiltroBloc bloc;

  const ListaItensEvento({Key key, this.status, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemEvento>>(
      stream: bloc.itensEvento,
      initialData: [],
      builder: (context, snapshot) {
        List<ItemEvento> itens =
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
                title: const IntlText("filtro.conteudo"),
              ),
              for (ItemEvento item in itens)
                ItemEventoCard(
                  item: item,
                ),
            ],
          ),
          secondChild: Container(),
        );
      },
    );
  }
}
