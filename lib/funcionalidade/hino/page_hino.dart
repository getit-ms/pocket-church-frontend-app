part of pocket_church.hino;

class PageHino extends StatelessWidget {
  final Hino hino;

  const PageHino({this.hino});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      title: IntlText(
        "hino.hino",
        args: {
          'numero': hino.numero,
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => _share(context),
        )
      ],
      body: FutureBuilder(
        future: hinoDAO.findHino(hino.id),
        builder: (context, snapshot) {
          return Container(
            color: Colors.white,
            child: _buildContent(snapshot.data ?? hino, tema),
          );
        },
      ),
    );
  }

  _share(BuildContext context) async {
    Configuracao config = ConfiguracaoApp.of(context).config;

    String tempFile = await arquivoService.downloadTemp(
      "${config.basePath}/hino/${hino.id}/${hino.filename.replaceAll(' ', '_')}'.pdf",
    );

    final ByteData bytes = await services.rootBundle.load(tempFile);

    Share.file(
      hino.nome,
      hino.filename + '.pdf',
      bytes.buffer.asUint8List(),
      'application/pdf',
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
              child: Html(data: hino.texto ?? "",
                defaultTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
