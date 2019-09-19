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
      {String url, String filename}) async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => LoadingSharingDialog(
        filename: filename,
        url: url,
      ),
    );
  }
}

class LoadingSharingDialog extends StatefulWidget {
  final int arquivo;
  final String url;
  final String filename;

  const LoadingSharingDialog({this.arquivo, this.url, this.filename});

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
      } else {
        file = File(await arquivoService.downloadTemp(
          widget.url,
        ));
      }

      final Uint8List bytes = await file.readAsBytes();

      await Share.file(
        widget.filename,
        widget.filename + '.pdf',
        bytes,
        'application/pdf',
      );

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
