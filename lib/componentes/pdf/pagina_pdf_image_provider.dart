part of pocket_church.componentes;

var lockRenderizacao = new Lock();

class PaginaPDFImageProvider extends ImageProvider<PaginaPDFImageProvider> {

  final PDFDocument document;
  final int numeroPagina;
  final double width;
  final double height;
  final double scale;

  const PaginaPDFImageProvider(this.document, this.numeroPagina, { this.scale = 1, this.width, this.height}):
        assert(document != null),
        assert(numeroPagina != null && numeroPagina >= 1);

  @override
  ImageStreamCompleter load(PaginaPDFImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: key.scale,
        informationCollector: () {
          return [DiagnosticsNode.message('Página PDF: $document $numeroPagina')];
        }
    );
  }

  @override
  Future<PaginaPDFImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<PaginaPDFImageProvider>(this);
  }

  int _getWidth(int originalWidth, int originalHeight) {
    if (width != null) {
      return width.toInt();
    }

    if (height != null) {
      return ((height / originalHeight) * originalWidth).toInt();
    }

    return (originalWidth * scale).toInt();
  }

  int _getHeight(int originalWidth, int originalHeight) {
    if (height != null) {
      return height.toInt();
    }

    if (width != null) {
      return ((width / originalWidth) * originalHeight).toInt();
    }

    return (originalHeight * scale).toInt();
  }

  Future<Codec> _loadAsync(PaginaPDFImageProvider key) async {
    assert(key == this);

    var pageImage = await lockRenderizacao.synchronized(() async {
      final page = await document.getPage(numeroPagina);
      try {
        return await page.render(
            format: PDFPageFormat.JPEG,
            width: _getWidth(page.width, page.height),
            height: _getHeight(page.width, page.height),
            backgroundColor: "#FFFFFFFF"
        );
      } finally {
        page.close();
      }
    });

    if (pageImage.bytes.lengthInBytes == 0)
      return null;

    return await PaintingBinding.instance.instantiateImageCodec(pageImage.bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;
    final PaginaPDFImageProvider typedOther = other;
    return document == typedOther.document
        && numeroPagina == numeroPagina
        && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(document, numeroPagina, scale);

  @override
  String toString() => '$runtimeType("$document", "$numeroPagina, scale: $scale)';
}
