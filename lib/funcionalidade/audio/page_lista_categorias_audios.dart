part of pocket_church.audio;

class PageListaCategoriasAudios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("audio.audios"),
      body: FutureBuilder<List<CategoriaAudio>>(
        future: audioApi.consultaCategorias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  CategoriaAudio categoria = snapshot.data[index];

                  return WidgetBody(
                    title: Text(categoria.nome),
                    body: Container(
                      height: 240,
                      child: InfiniteList(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        provider: (pagina, tamanho) async {
                          return await audioApi.consulta(
                            categoria: categoria.id,
                            pagina: pagina,
                            tamanhoPagina: tamanho,
                          );
                        },
                        builder: (context, itens, index) {
                          return ItemAudio(
                            audio: itens[index],
                          );
                        },
                        placeholderSize: 220,
                        placeholderBuilder: (context) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 210,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          );
                        },
                      ),
                    ),
                    onMore: () {
                      NavigatorUtil.navigate(
                        context,
                        builder: (context) => PageListaAudios(
                          categoria: categoria,
                        ),
                      );
                    },
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

