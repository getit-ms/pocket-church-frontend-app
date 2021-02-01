part of pocket_church.componentes;


typedef FileCallback = void Function(Arquivo arquivo);
typedef ExceptionCallback = void Function(dynamic exception, StackTrace tack);

class ProgressoUploadArquivo extends StatefulWidget {
  final String path;
  final Tema tema;
  final FileCallback fileCallback;
  final ExceptionCallback exceptionCallback;

  const ProgressoUploadArquivo(
      this.path, {
        @required this.fileCallback,
        this.exceptionCallback,
        @required this.tema,
      });

  @override
  State<StatefulWidget> createState() {
    return ProgressoUploadArquivoState();
  }
}

class ProgressoUploadArquivoState extends State<ProgressoUploadArquivo> {
  int received = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();

    arquivoService
        .uploadFile(widget.path, onProgress: _updateProgresso)
        .then((arquivo) {
      widget.fileCallback(arquivo);
    }).catchError((ex, stack) {
      Navigator.of(context).pop();

      if (widget.exceptionCallback != null) {
        widget.exceptionCallback(ex, stack);
      }
    });
  }

  _updateProgresso(received, total) {
    setState(() {
      this.received = received;
      this.total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = configuracaoBloc.currentTema;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.arrow_upward,
                size: 32,
                color: tema?.primary ?? Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: IntlText(
                  'global.realizando_upload',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          LinearProgressIndicator(
            value: total > 0 ? received / total : null,
            valueColor: AlwaysStoppedAnimation(widget.tema.primary),
            backgroundColor: widget.tema.primary.withOpacity(.5),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            child: DefaultTextStyle(
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                color: Colors.black,
              ),
              child: _descricaoProgresso(),
            ),
          )
        ],
      ),
    );
  }

  _byteLegivel(int bytes) {
    if (bytes > 1024) {
      int kbytes = (bytes / 1024).floor();

      if (kbytes > 1024) {
        int mbytes = (kbytes / 1024).floor();

        if (mbytes > 1024) {
          int gbytes = (mbytes / 1024).floor();

          return "${gbytes}GB";
        }

        return "${mbytes}MB";
      }

      return "${kbytes}KB";
    }

    return "${bytes}B";
  }

  Widget _descricaoProgresso() {
    if (total == 0) {
      return IntlText('global.conectando');
    }

    if (total < 0) {
      return Text(_byteLegivel(received));
    }

    return IntlText(
      "global.progresso_upload",
      args: {
        'current': _byteLegivel(received),
        'total': _byteLegivel(total),
      },
    );
  }
}


