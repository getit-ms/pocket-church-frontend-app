part of pocket_church.estudo;

class PageEstudo extends StatelessWidget {
  final Estudo estudo;

  const PageEstudo({this.estudo});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      title: const IntlText("estudo.estudo"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => _share(context),
        )
      ],
      body: FutureBuilder(
        future: estudoApi.detalha(estudo.id),
        builder: (context, snapshot) {
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(estudo.titulo,
                  style: TextStyle(
                    color: tema.primary,
                    fontSize: 25,
                  ),),
                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(estudo.autor),
                      Text(StringUtil.formatData(estudo.data, pattern: "dd MMMM yyyy"))
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Expanded(
                  child: _buildContent(snapshot.data ?? estudo),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _share(BuildContext context) async {
    Configuracao config = ConfiguracaoApp.of(context).config;

    String tempFile;
    if (estudo.tipo == 'TEXTO') {
      tempFile = await arquivoService.downloadTemp(
        "${config.basePath}/estudo/${estudo.id}/${estudo.filename.replaceAll(' ', '_')}'.pdf",
      );
    } else {
      var file = await arquivoService.getFile(estudo.pdf.id);

      tempFile = file.path;
    }

    final ByteData bytes = await services.rootBundle.load(tempFile);

    Share.file(
      estudo.titulo,
      estudo.filename + '.pdf',
      bytes.buffer.asUint8List(),
      'application/pdf',
    );
  }

  Widget _buildContent(Estudo estudo) {
    if (estudo.tipo == 'TEXTO') {
      return SingleChildScrollView(
        child: Html(
          data: estudo.texto ?? "",
          defaultTextStyle: TextStyle(
            letterSpacing: 1.05,
            height: 1.2,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      );
    } else {
      return ListaPaginasPDF(
        titulo: estudo.titulo,
        arquivo: estudo.pdf,
      );
    }
  }
}
