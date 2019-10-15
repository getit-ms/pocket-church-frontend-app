part of pocket_church.widgets_reativos;

class WidgetAudios extends StatefulWidget {
  const WidgetAudios();

  @override
  _WidgetAudiosState createState() => _WidgetAudiosState();
}

class _WidgetAudiosState extends State<WidgetAudios> {
  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText(
        "audio.audios",
      ),
      onMore: () {
        NavigatorUtil.navigate(context,
            builder: (context) => PageListaCategoriasAudios());
      },
      body: Container(
        height: 260,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          scrollDirection: Axis.horizontal,
          provider: (pagina, tamanho) async {
            return await audioApi.consulta(
                pagina: pagina, tamanhoPagina: tamanho);
          },
          builder: (context, itens, index) {
            return ItemAudio(
              audio: itens[index],
            );
          },
          placeholderSize: 260,
          placeholderBuilder: (context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 210,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            );
          },
        ),
      ),
    );
  }
}
