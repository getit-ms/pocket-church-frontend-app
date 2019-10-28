part of pocket_church.hino;

class PageHino extends StatelessWidget {
  final Hino hino;

  const PageHino({this.hino});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return FutureBuilder(
      future: hinoDAO.findHino(hino.id),
      builder: (context, snapshot) {
        return PageTemplate(
          title: IntlText(
            "hino.hino",
            args: {
              'numero': hino.numero,
            },
          ),
          actions: <Widget>[
            snapshot.hasData != null
                ? IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () => _share(context, snapshot.data ?? hino),
                  )
                : Container()
          ],
          body: Container(
            color: Colors.white,
            child: _buildContent(snapshot.data ?? hino, tema),
          ),
        );
      },
    );
  }

  _share(BuildContext context, Hino hino) async {
    Configuracao config = ConfiguracaoApp.of(context).config;

    ShareUtil.shareDownloadedFile(
      context,
      url:
          "${config.basePath}/hino/${hino.id}/${hino?.filename?.replaceAll(' ', '_')}'.pdf",
      filename: hino.filename,
    );
  }

  Widget _buildContent(Hino hino, Tema tema) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Text(
                hino.nome,
                style: TextStyle(
                  fontSize: 25,
                  color: tema.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Html(
                data: hino.texto ?? "",
                defaultTextStyle: TextStyle(
                  height: 2,
                  color: Colors.black54,
                  fontSize: 17,
                ),
                onLinkTap: (link) {
                  LaunchUtil.site(link);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
