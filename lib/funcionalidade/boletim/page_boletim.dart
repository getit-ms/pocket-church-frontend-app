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
          return _buildContent(snapshot.data ?? boletim);
        },
      ),
    );
  }

  _share(BuildContext context) async {
    ShareUtil.shareArquivo(
      context,
      arquivo: boletim.boletim.id,
      filename: boletim.boletim.filename,
    );
  }

  Widget _buildContent(Boletim boletim) {
    return ListaPaginasPDF(
      titulo: boletim.titulo,
      arquivo: boletim.boletim,
    );
  }
}
