part of pocket_church.publicacao;

class PagePublicacao extends StatelessWidget {

  final Boletim publicacao;

  const PagePublicacao({this.publicacao,});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("publicacao.publicacao"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => _share(context),
        )
      ],
      body: FutureBuilder(
        future: boletimApi.detalha(publicacao.id),
        builder: (context, snapshot) {
          return Container(
            color: Colors.white,
            child: _buildContent(snapshot.data ?? publicacao),
          );
        },
      ),
    );
  }

  _share(BuildContext context) async {
    var file = await arquivoService.getFile(publicacao.boletim.id);

    final ByteData bytes = await services.rootBundle.load(file.path);

    Share.file(
      publicacao.titulo,
      publicacao.boletim.filename + '.pdf',
      bytes.buffer.asUint8List(),
      'application/pdf',
    );
  }

  Widget _buildContent(Boletim publicacao) {
    return ListaPaginasPDF(
      titulo: publicacao.titulo,
      arquivo: publicacao.boletim,
    );
  }
}
