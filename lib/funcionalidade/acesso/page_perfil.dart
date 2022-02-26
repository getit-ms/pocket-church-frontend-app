part of pocket_church.funcionalidade_acesso;

class PagePerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return comp.PageTemplate(
      withAppBar: false,
      deveEstarAutenticado: true,
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        children: <Widget>[
          PerfilHeader(),
          StreamBuilder<Membro>(
              stream: acessoBloc.membro,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data?.nome ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                );
              }),
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<Membro>(
            stream: acessoBloc.membro,
            builder: (context, snapshot) {
              return Text(
                snapshot.data?.email ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RawMaterialButton(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: tema.primary,
                      size: 35,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const comp.IntlText("login.alterar_senha"),
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const DialogAlterarSenha(),
                  );
                },
              ),
              RawMaterialButton(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: tema.primary,
                      size: 35,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const comp.IntlText("preferencias.preferencias"),
                  ],
                ),
                onPressed: () {
                  NavigatorUtil.navigate(
                    context,
                    builder: (context) => PagePreferencias(),
                    replace: true,
                  );
                },
              ),
              RawMaterialButton(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: tema.primary,
                      size: 35,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const comp.IntlText("preferencias.logout"),
                  ],
                ),
                onPressed: () {
                  acessoBloc.logout();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class PerfilHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .5,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: tema.loginBackground,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topRight: const Radius.circular(50),
                topLeft: const Radius.circular(50),
              ),
            ),
            height: 50,
          ),
        ),
        Positioned(
          bottom: 30,
          left: MediaQuery.of(context).size.width / 2 - 90,
          child: Container(
            height: 180,
            width: 180,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5,
                  )
                ]),
            child: StreamBuilder<Membro>(
              stream: acessoBloc.membro,
              builder: (context, snapshot) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(90)),
                  child: comp.FotoMembro(snapshot?.data?.foto),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: MediaQuery.of(context).size.width / 2 + 25,
          child: RawMaterialButton(
            elevation: 10,
            fillColor: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(15),
            child: Icon(
              Icons.camera_alt,
              color: tema.primary,
            ),
            shape: const CircleBorder(),
            onPressed: () {
              ScaffoldState scaffoldState = Scaffold.of(context);

              showModalBottomSheet(
                context: context,
                builder: (ctx) => comp.BottomMenu(
                  height: 120,
                  items: [
                    comp.BottomMenuItem(
                      icon: Icons.photo_camera,
                      label: comp.IntlText("login.tirar_foto"),
                      action: () async {
                        Navigator.of(ctx).pop();

                        String path = await arquivoService.tiraFoto();

                        _atualizaFoto(context, scaffoldState, path);
                      },
                    ),
                    comp.BottomMenuItem(
                      icon: Icons.folder,
                      label: comp.IntlText("login.escolher_galeria"),
                      action: () async {
                        Navigator.of(ctx).pop();

                        String path = await arquivoService.selecionaImagem();

                        _atualizaFoto(context, scaffoldState, path);
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 0,
          top: MediaQuery.of(context).padding.top,
          child: BackButton(
            color: Colors.white70,
          ),
        )
      ],
    );
  }

  void _atualizaFoto(
      BuildContext context, ScaffoldState scaffoldState, String path) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            children: <Widget>[
              comp.ProgressoUploadArquivo(
                path,
                tema: ConfiguracaoApp.of(context).tema,
                fileCallback: (arquivo) async {
                  try {
                    await acessoApi.atualizaFoto(arquivo);

                    acessoBloc.refresh();
                  } catch (ex) {
                    comp.error.handle(scaffoldState, ex);
                  }

                  Navigator.of(ctx).pop();
                },
                exceptionCallback: (ex, stack) {
                  comp.error.handle(scaffoldState, ex);
                },
              )
            ],
          );
        });
  }
}

class DialogAlterarSenha extends StatefulWidget {
  const DialogAlterarSenha();

  @override
  State<StatefulWidget> createState() => DialogAlterarSenhaState();
}

class DialogAlterarSenhaState extends State<DialogAlterarSenha> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _senhaController;

  String _senha;
  String _confirmacaoSenha;

  @override
  void initState() {
    super.initState();

    _senhaController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Dialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                comp.IntlText(
                  "login.alterar_senha",
                  style: TextStyle(
                    fontSize: 22,
                    color: tema.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                comp.IntlBuilder(
                    text: "login.nova_senha",
                    builder: (context, snapshot) {
                      return TextFormField(
                        obscureText: true,
                        controller: _senhaController,
                        decoration: InputDecoration(
                          labelText: snapshot.data ?? "",
                        ),
                        validator: validate([notEmpty(), length(min: 6)]),
                        onSaved: (senha) => this._senha = senha,
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                comp.IntlBuilder(
                    text: "login.confirmacao_senha",
                    builder: (context, snapshot) {
                      return TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: snapshot.data ?? "",
                        ),
                        validator:
                            validate([notEmpty(), _validateConfirmacaoSenha]),
                        onSaved: (senha) => this._confirmacaoSenha = senha,
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: comp.CommandButton<void>(
                    child: const comp.IntlText("login.alterar_senha"),
                    onPressed: (loading) async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        FocusScope.of(context).requestFocus(new FocusNode());

                        try {
                          await loading(acessoApi.atualizaSenha(
                              novaSenha: _senha,
                              confirmacaoSenha: _confirmacaoSenha));

                          acessoBloc.logout();

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        } catch (ex) {
                          comp.error.handle(Scaffold.of(context), ex);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: comp.IntlText("global.cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validateConfirmacaoSenha(String confirmacao, Bundle bundle) {
    if ((confirmacao?.isNotEmpty ?? false) &&
        _senhaController.text != confirmacao) {
      return bundle['validacao.confirmacaoSenha'];
    }

    return null;
  }
}
