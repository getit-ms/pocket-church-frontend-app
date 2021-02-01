part of pocket_church.fotos;

class PageListaGalerias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("fotos.galerias"),
      deveEstarAutenticado: true,
      body: InfiniteList(
        provider: _provider,
        builder: _builder,
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
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://farm${galeria.fotoPrimaria.farm}.staticflickr.com/${galeria.fotoPrimaria.server}/${galeria.fotoPrimaria.id}_${galeria.fotoPrimaria.secret}_n.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
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
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      galeria.descricao ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
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
