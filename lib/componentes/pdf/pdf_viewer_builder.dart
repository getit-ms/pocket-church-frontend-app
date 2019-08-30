part of pocket_church.componentes;

typedef PDFViewerWidgetBuilder = Widget Function(BuildContext context, PDFRenderingSnapshot snapshot);

class PDFViewerBuilder extends StatefulWidget {
  final Arquivo arquivo;
  final PDFViewerWidgetBuilder builder;

  const PDFViewerBuilder({this.arquivo, this.builder});

  @override
  State<StatefulWidget> createState() => PDFViewerBuilderState();

}

class PDFViewerBuilderState extends State<PDFViewerBuilder> with TickerProviderStateMixin {

  PDFRenderingSnapshot snapshot = new PDFRenderingSnapshot();

  @override
  void initState() {
    super.initState();

    pdfService.render(widget.arquivo,
        onProgress: (snapshot) {
          setState(() {
            this.snapshot = snapshot;
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, snapshot);
  }

}