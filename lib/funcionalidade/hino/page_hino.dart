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
          body: _buildContent(context, snapshot.data ?? hino, tema),
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

  Widget _buildContent(BuildContext context, Hino hino, Tema tema) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20) +
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                hino.nome,
                style: TextStyle(
                  fontSize: 25,
                  color: tema.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomHtml(
              html: hino.texto ?? "",
            ),
          ],
        ),
      ),
    );
  }
}
