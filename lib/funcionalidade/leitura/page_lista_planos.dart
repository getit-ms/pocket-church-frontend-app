part of pocket_church.leitura;

class PageListaPlanos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      deveEstarAutenticado: true,
      title: const IntlText("leitura.planos_leitura"),
      body: InfiniteList(provider: _provider, builder: _builder),
    );
  }

  Widget _builder(BuildContext context, List<PlanoLeitura> itens, int index) {
    PlanoLeitura item = itens[index];
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Tema tema = ConfiguracaoApp.of(context).tema;

    return RawMaterialButton(
      elevation: 6,
      fillColor: isDark ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(child: Text(item.descricao)),
          const SizedBox(width: 10),
          Icon(
            Icons.chevron_right,
            color: tema.primary,
          ),
        ],
      ),
      onPressed: () async {
        await leituraApi.selecionaPlano(item.id);

        leituraBloc.sincroniza();

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageLeitura(),
            replace: true,
          );
        }
      },
    );
  }

  Future<Pagina<PlanoLeitura>> _provider(int pagina, int tamanhoPagina) async {
    return await leituraApi.consultaPlanos(
      dataInicio: DateTime.now(),
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
    );
  }
}
