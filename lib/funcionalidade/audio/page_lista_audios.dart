part of pocket_church.audio;

class PageListaAudios extends StatelessWidget {
  final CategoriaAudio categoria;

  const PageListaAudios({this.categoria});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text(categoria.nome),
      body: InfiniteList(
        padding: const EdgeInsets.symmetric(
            vertical: 10
        ),
        provider: _provider,
        builder: _builder,
      ),
    );
  }

  Future<Pagina<Audio>> _provider(int pagina, int tamanhoPagina) async {
    return await audioApi.consulta(
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
      categoria: categoria.id,
    );
  }

  Widget _builder(BuildContext context, List<Audio> itens, int index) {
    Audio audio = itens[index];

    if (index % 2 == 0) {
      return Container(
        padding: const EdgeInsets.all(5),
        height: 240,
        child: Row(
          children: <Widget>[
            Expanded(child: new ItemAudio(audio: audio)),
            Expanded(
              child: index + 1 < itens.length
                  ? new ItemAudio(
                      audio: itens[index + 1],
                    )
                  : Container(),
            )
          ],
        ),
      );
    }

    return Container();
  }
}
