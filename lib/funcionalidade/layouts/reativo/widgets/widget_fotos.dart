part of pocket_church.widgets_reativos;

class WidgetFotos extends StatelessWidget {
  const WidgetFotos();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText("fotos.fotos"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaGalerias(),
        );
      },
      body: Container(
        height: 220,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          scrollDirection: Axis.horizontal,
          provider: _provider,
          builder: _builder,
          placeholderSize: 210,
          placeholderBuilder: (context) => Container(
            width: 200,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, List<GaleriaFotos> itens, int index) {
    GaleriaFotos galeria = itens[index];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomElevatedButton(
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageListaFotos(
              galeria: galeria,
            ),
          );
        },
        child: Hero(
          tag: "galeria_" + galeria.id,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: double.infinity,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://farm${galeria.fotoPrimaria.farm}.staticflickr.com/${galeria.fotoPrimaria.server}/${galeria.fotoPrimaria.id}_${galeria.fotoPrimaria.secret}_n.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      galeria.nome,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Pagina<GaleriaFotos>> _provider(int pagina, int tamanhoPagina) async {
    return await fotoApi.consultaGalerias(
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
    );
  }
}
