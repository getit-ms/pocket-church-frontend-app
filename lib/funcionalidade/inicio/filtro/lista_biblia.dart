part of pocket_church.inicio;


class ListaBiblia extends StatelessWidget {
  final StatusFiltro status;
  final FiltroBloc bloc;

  const ListaBiblia({Key key, this.status, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<VersiculoBiblia>>(
      stream: bloc.versiculos,
      initialData: [],
      builder: (context, snapshot) {
        List<VersiculoBiblia> versiculos =
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
                title: const IntlText("filtro.biblia"),
              ),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  itemCount: versiculos.length,
                  itemBuilder: (context, index) {
                    return _ItemVersiculo(versiculo: versiculos[index]);
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

class _ItemVersiculo extends StatelessWidget {
  final VersiculoBiblia versiculo;

  const _ItemVersiculo({Key key, this.versiculo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      active: versiculo == null,
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;
    var mq = MediaQuery.of(context);
    return GestureDetector(
      onTap: versiculo != null
          ? () {
              NavigatorUtil.navigate(
                context,
                builder: (context) => PageBiblia(
                  livroCapitulo: versiculo.livroCapitulo,
                ),
              );
            }
          : null,
      child: SizedBox(
        width: mq.size.width * .40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            versiculo != null
                ? Text(
              "${versiculo.livroCapitulo.livro.nome} ${versiculo.capitulo}:${versiculo.versiculo}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tema.primary,
              ),
            )
                : Container(height: 16, color: Colors.white),
            const SizedBox(height: 10),
            versiculo?.texto != null
                ? Text(
                    versiculo.texto,
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
