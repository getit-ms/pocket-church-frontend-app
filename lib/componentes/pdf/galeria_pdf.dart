part of pocket_church.componentes;

class GaleriaPDF extends StatefulWidget {
  final String titulo;
  final Arquivo arquivo;
  final int initialPage;

  const GaleriaPDF({this.titulo, this.arquivo, this.initialPage = 1});

  @override
  State<StatefulWidget> createState() => GaleriaPDFState();
}

class GaleriaPDFState extends State<GaleriaPDF> with TickerProviderStateMixin {
  PageController _pageController;
  bool showTools = true;
  int totalPaginas = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showTools = !showTools;
        });
      },
      child: PDFViewerBuilder(
        arquivo: widget.arquivo,
        builder: (context, snapshot) {
          if (snapshot.status == PDFRenderingStatus.done) {
            if (_pageController == null) {
              _pageController = new PageController(initialPage: widget.initialPage - 1);
              totalPaginas = snapshot.pdf.paginas.length;
            }

            return _template(child: _rendering(snapshot.pdf));
          } else if (snapshot.status == PDFRenderingStatus.error) {
            return _template(child: _error(snapshot.error));
          } else {
            return _template(child: _waiting());
          }
        },
      ),
    );
  }

  Widget _template({Widget child}) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
        child,
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimatedCrossFade(
                firstChild: Container(),
                secondChild: AppBar(
                  centerTitle: true,
                  title: Text(widget.titulo ?? ""),
                  backgroundColor: Colors.transparent,
                ),
                crossFadeState: showTools
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              AnimatedCrossFade(
                firstChild: Container(),
                secondChild: Container(
                  height: MediaQuery.of(context).padding.bottom +
                      kToolbarHeight,
                  color: Colors.black45,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: totalPaginas > 0
                      ? PageNavigation(
                    controller: _pageController,
                    totalPages: totalPaginas,
                  )
                      : null,
                ),
                crossFadeState: showTools
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              )
            ],
          ),
        )
        ],
      ),
    );
  }

  Widget _rendering(ArquivoPDF arquivoPDF) {
    return PhotoViewGallery(
      pageOptions: arquivoPDF.paginas
          .map((pag) => PhotoViewGalleryPageOptions(
              imageProvider: FileImage(pag.file),
              heroTag: 'pagina_' + pag.number.toString()))
          .toList(),
      gaplessPlayback: true,
      pageController: _pageController,
      backgroundDecoration: BoxDecoration(
        color: Colors.black87,
      ),
    );
  }

  Widget _error(dynamic ex) {
    return Center(
      child: error.resolveMessage(ex),
    );
  }

  Widget _waiting() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class PageNavigation extends StatefulWidget {
  final PageController controller;
  final int totalPages;

  const PageNavigation({
    this.controller,
    this.totalPages,
  });

  @override
  _PageNavigationState createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_onChange);
  }

  int get page => (widget.controller.page?.round() ?? widget.controller.initialPage) + 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          disabledColor: Colors.white24,
          icon: Icon(Icons.chevron_left),
          onPressed: page > 1
              ? () {
                  widget.controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              : null,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: IntlText(
              "global.paginacao",
              args: {
                'atual': page.toString(),
                'total': widget.totalPages.toString()
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
        IconButton(
          disabledColor: Colors.white24,
          icon: Icon(Icons.chevron_right),
          onPressed: page < widget.totalPages
              ? () {
                  widget.controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              : null,
        ),
      ],
    );
  }

  void _onChange() {
    setState(() {});
  }
}
