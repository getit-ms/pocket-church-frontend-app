part of pocket_church.boletim;

class PageBoletim extends StatelessWidget {
  final Boletim boletim;

  const PageBoletim({
    this.boletim,
  });

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("boletim.boletim"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => _share(context),
        )
      ],
      body: FutureBuilder(
        future: boletimApi.detalha(boletim.id),
        builder: (context, snapshot) {
          return Container(
            color: Colors.white,
            child: _buildContent(snapshot.data ?? boletim),
          );
        },
      ),
    );
  }

  _share(BuildContext context) async {
    var file = await arquivoService.getFile(boletim.boletim.id);

    final ByteData bytes = await services.rootBundle.load(file.path);

    Share.file(
      boletim.titulo,
      boletim.boletim.filename + '.pdf',
      bytes.buffer.asUint8List(),
      'application/pdf',
    );
  }

  Widget _buildContent(Boletim boletim) {
    return ListaPaginasPDF(
      titulo: boletim.titulo,
      arquivo: boletim.boletim,
    );
  }
}
