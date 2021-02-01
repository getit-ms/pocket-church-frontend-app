part of pocket_church.widgets_reativos;

class WidgetEstudos extends StatelessWidget {
  const WidgetEstudos();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText(
        "estudo.estudos",
      ),
      onMore: () {
        NavigatorUtil.navigate(context,
            builder: (context) => PageListaCategoriasEstudos());
      },
      body: Container(
        height: 270,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          scrollDirection: Axis.horizontal,
          provider: (pagina, tamanho) async {
            return await estudoApi.consulta(
                pagina: pagina, tamanhoPagina: tamanho);
          },
          builder: (context, itens, index) {
            return ItemEstudo(estudo: itens[index]);
          },
          placeholderSize: 180,
          placeholderBuilder: (context) {
            return Container(
              margin: const EdgeInsets.all(10),
              width: 160,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            );
          },
        ),
      ),
    );
  }
}
