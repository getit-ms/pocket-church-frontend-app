part of pocket_church.estudo;

class PageEstudo extends StatelessWidget {
  final Estudo estudo;

  const PageEstudo({this.estudo});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return FutureBuilder(
      future: estudoApi.detalha(estudo.id),
      builder: (context, snapshot) {
        return PageTemplate(
          title: const IntlText("estudo.estudo"),
          actions: <Widget>[
            snapshot.hasData
                ? IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () => _share(context, snapshot.data ?? estudo),
                  )
                : Container()
          ],
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  estudo.titulo,
                  style: TextStyle(
                    color: tema.primary,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(estudo.autor),
                    Text(StringUtil.formatData(estudo.data,
                        pattern: "dd MMMM yyyy"))
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: _buildContent(context, snapshot.data ?? estudo),
              ),
            ],
          ),
        );
      },
    );
  }

  _share(BuildContext context, Estudo estudo) async {
    if (estudo.tipo == 'TEXTO') {
      Configuracao config = ConfiguracaoApp.of(context).config;

      ShareUtil.shareDownloadedFile(
        context,
        url:
            "${config.basePath}/estudo/${estudo.id}/${estudo.filename.replaceAll(' ', '_')}'.pdf",
        filename: estudo.filename,
      );
    } else {
      ShareUtil.shareArquivo(
        context,
        arquivo: estudo.pdf.id,
        filename: estudo.filename,
      );
    }
  }

  Widget _buildContent(BuildContext context, Estudo estudo) {
    if (estudo.tipo == 'TEXTO') {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(10) +
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: CustomHtml(
          html: estudo.texto ?? "",
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
