part of pocket_church.infra;

enum PDFRenderingStatus {
  waiting,
  downloading,
  rendering,
  done,
  error
}

class PDFRenderingSnapshot {
  final PDFRenderingStatus status;
  final double statusProgress;
  final ArquivoPDF pdf;
  final dynamic error;

  const PDFRenderingSnapshot({
    this.status = PDFRenderingStatus.waiting,
    this.statusProgress = 0,
    this.pdf,
    this.error
  });

  PDFRenderingSnapshot derive({
    PDFRenderingStatus status,
    double statusProgress,
    ArquivoPDF pdf,
    dynamic error
  }) {
    return PDFRenderingSnapshot(
      status: status??this.status,
      statusProgress: statusProgress??this.statusProgress,
      pdf: pdf??this.pdf,
      error: error??this.error,
    );
  }
}

typedef PDFRenderingCallback = Function(PDFRenderingSnapshot snapshot);

class PDFService {
  double _width;
  double _height;

  PDFService();

  configure({double width, double height}) {
    this._width = width;
    this._height = height;
  }

  Future<ArquivoPDF> render(Arquivo arquivo, {
    PDFRenderingCallback onProgress
  }) async {
    PDFRenderingSnapshot snapshot = new PDFRenderingSnapshot();

    try {
      File pdfFile = await arquivoService.getFile(arquivo.id,
          onProgress: (received, total) {
            if (onProgress != null) {
              onProgress(snapshot.derive(
                  status: PDFRenderingStatus.downloading,
                  statusProgress: received.toDouble() / total.toDouble()
              ));
            }
          }
      );

      ArquivoPDF arq = await renderArquivoPDF(pdfFile, onProgress, snapshot, arquivo);

      if (onProgress != null) {
        onProgress(snapshot.derive(
            status: PDFRenderingStatus.done,
            statusProgress: 1,
            pdf: arq
        ));
      }

      return arq;
    } catch (ex) {
      if (onProgress != null) {
        onProgress(snapshot.derive(
          error: ex,
          status: PDFRenderingStatus.error,
        ));
      }

      throw ex;
    }
  }

  Future<ArquivoPDF> renderArquivoPDF(File pdfFile, PDFRenderingCallback onProgress, PDFRenderingSnapshot snapshot, Arquivo arquivo) async {
    ArquivoPDF arq = await _prepareArquivoPDF(pdfFile);

    var doc = await PdfDocument.openFile(pdfFile.path);

    try {
      if (onProgress != null) {
        onProgress(snapshot.derive(
            status: PDFRenderingStatus.rendering,
            statusProgress: 0,
            pdf: arq
        ));
      }

      for (int pag = 1; pag <= doc.pagesCount; pag++) {
        PaginaPDF paginaPDF = await _renderPage(arquivo.id, doc, pag);

        arq.paginas.replaceRange(pag - 1, pag, [ paginaPDF ]);

        if (onProgress != null) {
          onProgress(snapshot.derive(
              status: PDFRenderingStatus.rendering,
              statusProgress: pag.toDouble() / doc.pagesCount.toDouble(),
              pdf: arq
          ));
        }
      }

      return arq;
    } finally {
      doc.close();
    }
  }

  int _parseWidth(int width, int height) {
    if (_width != null) {
      return _width.toInt();
    }

    if (_height != null) {
      return ((_height / height) * width).toInt();
    }

    return width;
  }

  int _parseHeight(int width, int height) {
    if (_height != null) {
      return _height.toInt();
    }

    if (_width != null) {
      return ((_width / width) * height).toInt();
    }

    return height;
  }

  Future<PaginaPDF> _loadPage(PdfDocument doc, int pgNumber) async {
    PdfPage page = await doc.getPage(pgNumber);
    try {
      return new PaginaPDF(
          number: pgNumber,
          width: page.width.toDouble(),
          height: page.height.toDouble()
      );
    } finally {
      page.close();
    }
  }

  Future<PaginaPDF> _renderPage(int arqId, PdfDocument doc, int pgNumber) async {
    File pageFile = await _pageFile(arqId, pgNumber);

    PdfPage page = await doc.getPage(pgNumber);
    try {
      if (!pageFile.existsSync()) {
        if (!pageFile.parent.existsSync()) {
          pageFile.parent.createSync(recursive: true);
        }

        PdfPageImage pageImage = await page.render(
            width: _parseWidth(page.width, page.height),
            height: _parseHeight(page.width, page.height),
            backgroundColor: '#ffffff'
        );

        await pageFile.writeAsBytes(
            pageImage.bytes
        );
      }

      return new PaginaPDF(
          number: pgNumber,
          file: pageFile,
          width: page.width.toDouble(),
          height: page.height.toDouble()
      );
    } finally {
      page.close();
    }
  }

  Future<File> _pageFile(int arq, int pagina) async {
    String basePath = await arquivoService.tempDir;
    return File("${basePath}pdfs/arq_$arq/$pagina.png");
  }

  Future<ArquivoPDF> _prepareArquivoPDF(File pdfFile) async {
    var doc = await PdfDocument.openFile(pdfFile.path);
    try {

      List<PaginaPDF> paginas = [];
      for (int pag = 1; pag <= doc.pagesCount; pag++) {
        paginas.add(
            await _loadPage(doc, pag)
        );
      }

      return new ArquivoPDF(paginas);
    } finally {
      doc.close();
    }
  }


}

class ArquivoPDF {
  final List<PaginaPDF> paginas;

  const ArquivoPDF(this.paginas);
}

class PaginaPDF {
  final int number;
  final File file;
  final double width;
  final double height;

  const PaginaPDF({this.number, this.file, this.width, this.height});
}

final PDFService pdfService = new PDFService();
