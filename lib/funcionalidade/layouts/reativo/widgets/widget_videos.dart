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
        height: 270,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
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
          placeholderSize: 250,
          placeholderBuilder: (context) {
            return Container(
              margin: const EdgeInsets.all(10),
              child: CustomElevatedButton(
                child: Container(
                  width: 230,
                ),
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
      padding: const EdgeInsets.all(10),
      child: CustomElevatedButton(
        onPressed: () {
          LaunchUtil.youtube(video.id);
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 2,
                    colors: [
                      tema.primary,
                      tema.secondary,
                    ],
                  ),
                  image: DecorationImage(
                    image: NetworkImage(video.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.youtube,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 75,
              padding: const EdgeInsets.all(10),
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
                    children: <Widget>[
                      Text(
                        StringUtil.formatDataLegivel(
                          video.publicacao,
                          configuracaoBloc.currentBundle,
                          porHora: true,
                          pattern: "dd MMM",
                        ),
                      )
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
