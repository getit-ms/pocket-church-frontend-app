part of pocket_church.componentes;

enum TipoAnexo { IMAGEM, TODOS }

class InputAnexo extends StatelessWidget {
  final ValueChanged<Arquivo> onSaved;
  final InputDecoration decoration;
  final TipoAnexo tipoAnexo;
  final FormFieldValidator<Arquivo> validator;

  const InputAnexo({
    Key key,
    this.onSaved,
    this.decoration,
    this.validator,
    this.tipoAnexo = TipoAnexo.TODOS,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<Arquivo>(
      onSaved: onSaved,
      validator: validator,
      builder: (field) {
        return InputDecorator(
          isEmpty: field.value == null,
          decoration: (decoration ?? InputDecoration()).copyWith(
            errorText: field.errorText,
            suffixIcon: field.value != null
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.black54),
                    onPressed: () async {
                      field.didChange(null);
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.folder_open,
                      color: Colors.black54,
                    ),
                    onPressed: _chooseFile(context, field),
                  ),
          ),
          child: GestureDetector(
            onTap: _chooseFile(context, field),
            child: Text(
              field.value?.nome ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        );
      },
    );
  }

  _enviaAnexo(BuildContext context, ScaffoldState scaffoldState,
      FormFieldState<Arquivo> field, String path) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            children: <Widget>[
              ProgressoUploadArquivo(
                path,
                tema: configuracaoBloc.currentTema,
                fileCallback: (arquivo) async {
                  field.didChange(arquivo);

                  Navigator.of(ctx).pop();
                },
                exceptionCallback: (ex, stack) {
                  error.handle(scaffoldState, ex);
                },
              ),
            ],
          );
        });
  }

  _chooseFile(BuildContext context, FormFieldState<Arquivo> field) {
    return () async {
      String path = tipoAnexo == TipoAnexo.IMAGEM
          ? await arquivoService.selecionaImagem()
          : await arquivoService.selecionaArquivo();

      if (path != null) {
        _enviaAnexo(context, Scaffold.of(context), field, path);
      }
    };
  }
}
