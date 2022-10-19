part of pocket_church.inicio;

class ListaHinos extends StatelessWidget {
  final StatusFiltro status;
  final FiltroBloc bloc;

  const ListaHinos({Key key, this.status, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Hino>>(
      stream: bloc.hinos,
      initialData: [],
      builder: (context, snapshot) {
        List<Hino> hinos =
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
                title: const IntlText("filtro.hinos"),
              ),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  itemCount: hinos.length,
                  itemBuilder: (context, index) {
                    return _ItemHino(hino: hinos[index]);
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

class _ItemHino extends StatelessWidget {
  final Hino hino;

  const _ItemHino({Key key, this.hino}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      active: hino == null,
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;
    var mq = MediaQuery.of(context);
    return GestureDetector(
      onTap: hino != null
          ? () {
              NavigatorUtil.navigate(
                context,
                builder: (context) => PageHino(
                  hino: hino,
                ),
              );
            }
          : null,
      child: SizedBox(
        width: mq.size.width * .66,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 10,
                  ),
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(),
                    color: tema.primary,
                  ),
                  child: hino != null
                      ? Text(
                          hino.numero,
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          "000",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: hino != null
                      ? Text(
                          hino.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tema.primary,
                          ),
                        )
                      : Container(height: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            hino?.texto != null
                ? Text(
                    hino.texto,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white),
                      SizedBox(height: 3),
                      Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white),
                      SizedBox(height: 3),
                      Container(height: 14, width: 50, color: Colors.white),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
