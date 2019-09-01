part of pocket_church.video;

class PageListaVideos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      title: IntlText("youtube.videos"),
      body: FutureBuilder<List<Video>>(
        future: videoApi.consulta(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data?.isNotEmpty ?? false) {
              List<Video> aoVivo =
                  snapshot.data.where((v) => v.aoVivo).toList();
              List<Video> historico =
                  snapshot.data.where((v) => !v.aoVivo).toList();

              return ListView.builder(
                itemCount: aoVivo.length +
                    historico.length +
                    (historico.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (aoVivo.isNotEmpty && index < aoVivo.length) {
                    Video video = snapshot.data[index];
                    return _buildItemAoVivo(video, tema);
                  }

                  var indexHistorico = index - aoVivo.length;
                  if (indexHistorico == 0) {
                    return InfoDivider(
                      child: const IntlText("youtube.historico_videos_cultos"),
                    );
                  }

                  Video video = snapshot.data[indexHistorico - 1];
                  return _buildItemHistorico(video, tema);
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

  RawMaterialButton _buildItemAoVivo(Video video, Tema tema) {
    return RawMaterialButton(
      fillColor: Colors.white,
      onPressed: () =>
          LaunchUtil.youtube(video.id),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(video.thumbnail),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    video.titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    video.descricao ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RawMaterialButton _buildItemHistorico(Video video, Tema tema) {
    return RawMaterialButton(
      fillColor: Colors.white,
      onPressed: () =>
          LaunchUtil.youtube(video.id),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Container(
                height: 80,
                width: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(video.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black38,
                  child: const Icon(FontAwesomeIcons.youtube),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    video.titulo,
                    style: TextStyle(
                      color: tema.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(video.descricao ?? ""),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
