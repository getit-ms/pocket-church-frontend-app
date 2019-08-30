part of pocket_church.estudo;

class PageListaEstudos extends StatelessWidget {
  final CategoriaEstudo categoria;

  const PageListaEstudos({this.categoria});

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

  Future<Pagina<Estudo>> _provider(int pagina, int tamanhoPagina) async {
    return await estudoApi.consulta(
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
      categoria: categoria.id,
    );
  }

  Widget _builder(BuildContext context, List<Estudo> itens, int index) {
    Estudo estudo = itens[index];

    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ItemEstudo(estudo: estudo),
          ),
        ),
      ],
    );
  }
}
