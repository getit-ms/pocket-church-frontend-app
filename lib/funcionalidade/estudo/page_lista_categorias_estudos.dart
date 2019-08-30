part of pocket_church.estudo;

class PageListaCategoriasEstudos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("estudo.estudos"),
      body: FutureBuilder<List<CategoriaEstudo>>(
        future: estudoApi.consultaCategorias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  CategoriaEstudo categoria = snapshot.data[index];

                  return WidgetBody(
                    title: Text(categoria.nome),
                    onMore: () {
                      NavigatorUtil.navigate(
                        context,
                        builder: (context) => PageListaEstudos(
                          categoria: categoria,
                        ),
                      );
                    },
                    body: Container(
                      height: 100,
                      child: InfiniteList(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        provider: (pagina, tamanho) async {
                          return await estudoApi.consulta(
                            categoria: categoria.id,
                            pagina: pagina,
                            tamanhoPagina: tamanho,
                          );
                        },
                        builder: (context, itens, index) {
                          return ItemEstudo(estudo: itens[index]);
                        },
                        placeholderSize: 180,
                        placeholderBuilder: (context) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            width: 270,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {}

            return Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: const IntlText("global.nenhum_registro_encontrado"),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
