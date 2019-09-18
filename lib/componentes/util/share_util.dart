part of pocket_church.componentes;

class ShareUtil {
  static Future<bool> shareArquivo(BuildContext context,
      {int arquivo, String filename}) async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => LoadingSharingDialog(
        filename: filename,
        arquivo: arquivo,
      ),
    );
  }

  static Future<bool> shareDownloadedFile(BuildContext context,
      {String url, String filename, bool downloadOnly = false}) async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => LoadingSharingDialog(
        filename: filename,
        url: url,
        downloadOnly: downloadOnly,
      ),
    );
  }
}

class LoadingSharingDialog extends StatefulWidget {
  final int arquivo;
  final String url;
  final String filename;
  final bool downloadOnly;

  const LoadingSharingDialog(
      {this.arquivo, this.downloadOnly = false, this.url, this.filename});

  @override
  _LoadingSharingDialogState createState() => _LoadingSharingDialogState();
}

class _LoadingSharingDialogState extends State<LoadingSharingDialog> {
  @override
  void initState() {
    super.initState();

    _doShare();
  }

  _doShare() async {
    try {
      var file;

      if (widget.arquivo != null) {
        file = await arquivoService.getFile(widget.arquivo);
      } else if (widget.downloadOnly) {
        file = File(await arquivoService.download(
          widget.url,
          widget.filename,
        ));
      } else {
        file = File(await arquivoService.downloadTemp(
          widget.url,
        ));
      }

      if (!widget.downloadOnly) {
        final Uint8List bytes = await file.readAsBytes();

        await Share.file(
          widget.filename,
          widget.filename + '.pdf',
          bytes,
          'application/pdf',
        );
      }

      Navigator.of(context).pop(true);
    } catch (ex) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CupertinoAlertDialog(
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
