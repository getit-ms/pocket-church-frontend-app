part of pocket_church.componentes;

class GaleriaPDF extends StatefulWidget {
  final String titulo;
  final Arquivo arquivo;
  final int initialPage;

  const GaleriaPDF({
    this.titulo,
    this.arquivo,
    this.initialPage = 1
  });

  @override
  State<StatefulWidget> createState() => GaleriaPDFState();

}

class GaleriaPDFState extends State<GaleriaPDF> with TickerProviderStateMixin {

  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.black,
          child: SafeArea(
            child: PDFViewerBuilder(
              arquivo: widget.arquivo,
              builder: (context, snapshot) {
                if (snapshot.status == PDFRenderingStatus.done) {
                  return _rendering(snapshot.pdf);
                } else if (snapshot.status == PDFRenderingStatus.error) {
                  return _error(snapshot.error);
                } else {
                  return _waiting();
                }
              },
            ),
          ),
        ),
        Container(
          child: Column(
            children: <Widget>[
              AppBar(
                centerTitle: true,
                title: Text(widget.titulo??""),
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _rendering(ArquivoPDF arquivoPDF) {
    if (_pageController == null) {
      _pageController = new PageController(initialPage: widget.initialPage - 1);
    }

    return PhotoViewGallery(
      pageOptions: arquivoPDF.paginas.map((pag) => PhotoViewGalleryPageOptions(
          imageProvider: FileImage(pag.file),
          heroTag: 'pagina_' + pag.number.toString()
      )).toList(),
      gaplessPlayback: true,
      pageController: _pageController,
      backgroundDecoration: BoxDecoration(
          color: Colors.black87
      ),
    );
  }

  Widget _error(dynamic error) {
    return Center(
      child: Text("Ocorreu um erro"),
    );
  }

  Widget _waiting() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

}

