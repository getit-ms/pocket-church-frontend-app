part of pocket_church.widgets_reativos;

class WidgetVideos extends StatelessWidget {
  const WidgetVideos();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText(
        "youtube.videos",
      ),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaVideos(),
        );
      },
      body: Container(
        height: 250,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          scrollDirection: Axis.horizontal,
          provider: (pagina, tamanho) async {
            List<Video> videos = await videoApi.consulta();

            return Pagina<Video>(
                resultados: videos,
                hasProxima: false,
                pagina: 1,
                totalPaginas: 1,
                totalResultados: videos?.length ?? 0);
          },
          builder: (context, itens, index) {
            return _ItemVideo(video: itens[index]);
          },
          placeholderSize: 260,
          placeholderBuilder: (context) {
            return Container(
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemVideo extends StatelessWidget {
  final Video video;

  const _ItemVideo({this.video});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: RawMaterialButton(
        onPressed: () {
          LaunchUtil.site("https://www.youtube.com/watch?v=${video.id}");
        },
        fillColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 2,
                      colors: [
                        tema.primary,
                        tema.primary.withOpacity(.25),
                      ],
                    ),
                    image: DecorationImage(
                        image: NetworkImage(video.thumbnail),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.black26,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.youtube,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              height: 65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    video.titulo,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: tema.primary, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: Text(
                          video.descricao ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(StringUtil.formatData(video.publicacao,
                          pattern: "dd MMM"))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
