part of pocket_church.inicio;

class TabTimeline extends StatefulWidget {
  @override
  _TabTimelineState createState() => _TabTimelineState();
}

class _TabTimelineState extends State<TabTimeline> {
  Key _aniversario = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InfiniteList<ItemEvento>(
      padding: const EdgeInsets.symmetric(vertical: 10),
      provider: (pagina, tamanho) async {
        return await itemEventoApi.consultaTimeline(
          pagina: pagina,
          tamanhoPagina: tamanho,
        );
      },
      builder: (context, itens, index) {
        ItemEvento item = itens[index];
        return ItemEventoCard(item: item);
      },
      placeholderCount: 3,
      placeholderSize: 380,
      placeholderShimmer: false,
      placeholderBuilder: (context) {
        return ItemEventoCard(item: null);
      },
      preChildren: [
        CardAniversariantes(
          key: _aniversario,
        ),
        CardBanners(),
        CardEnquetes(),
      ],
    );
  }
}
