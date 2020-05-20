part of pocket_church.funcionalidade_acesso;

class PageLogin extends StatefulWidget {
  final bool showMensagemAlteracaoSenha;
  final bool cadastro;

  const PageLogin(
      {this.cadastro = false, this.showMensagemAlteracaoSenha = false});

  @override
  State<StatefulWidget> createState() => PageLoginState();
}

class PageLoginState extends State<PageLogin> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _page = 'login';

  Bundle _bundle;

  StreamSubscription<Bundle> _subscription;

  GlobalKey<FormState> _form = new GlobalKey<FormState>();

  String _email;
  String _senha;
  String _nome;
  String _telefone;

  @override
  void initState() {
    super.initState();

    if (widget.cadastro) {
      _page = 'cadastro';
    }

    this._subscription = configuracaoBloc.bundle.listen((bundle) {
      setState(() {
        this._bundle = bundle;
      });
    });

    if (widget.showMensagemAlteracaoSenha) {
      Timer(const Duration(milliseconds: 800), () {
        comp.MessageHandler.success(_scaffoldKey.currentState,
            const comp.IntlText("mensagens.MSG-031"));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;

    var mediaQueryData = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (_page != 'login' && !widget.cadastro) {
          setState(() {
            _form.currentState.reset();
            _page = 'login';
          });
          return false;
        }

        return true;
      },
      child: Container(
        height: mediaQueryData.size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: tema?.loginBackground,
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                tema.primary.withOpacity(.75),
                tema.secondary.withOpacity(.75)
              ],
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              key: _scaffoldKey,
              body: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppBar(
                        centerTitle: true,
                        elevation: 0,
                        iconTheme: IconThemeData(color: Colors.white),
                        backgroundColor: Colors.transparent,
                        title: _buildTitle(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: tema.loginLogo,
                            height: 80,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _buildForm(),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  AnimatedCrossFade _buildTitle() {
    return AnimatedCrossFade(
      firstChild: comp.IntlText(
        "login.autenticar",
        style: TextStyle(color: Colors.white),
      ),
      secondChild: comp.IntlText(
        _page == 'cadastro' ? "login.novo_cadastro" : "login.redefinir_senha",
        style: TextStyle(color: Colors.white),
      ),
      crossFadeState: _page == 'login'
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }

  Form _buildForm() {
    return Form(
      key: _form,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            _buildNome(),
            _buildEmail(),
            _buildTelefone(),
            _buildSenha(),
            const SizedBox(
              height: 30,
            ),
            _buildAction(),
            const SizedBox(
              height: 10,
            ),
            _buildOptions(),
          ],
        ),
      ),
    );
  }

  AnimatedCrossFade _buildNome() {
    return AnimatedCrossFade(
      firstChild: new LoginInput(
        label: "login.nome",
        enabled: _page == 'cadastro',
        validator: validate(
          [
            notEmpty(),
          ],
          bundle: _bundle,
          enabled: _page == 'cadastro',
        ),
        onSaved: (val) => _nome = val,
      ),
      secondChild: Container(),
      crossFadeState: _page == 'cadastro'
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }

  LoginInput _buildEmail() {
    return new LoginInput(
      label: "login.email",
      validator: validate(
        [notEmpty(), email()],
        bundle: _bundle,
      ),
      onSaved: (val) => _email = val,
    );
  }

  AnimatedCrossFade _buildTelefone() {
    return AnimatedCrossFade(
      firstChild: new LoginInput(
        keyboardType: TextInputType.phone,
        label: "login.telefone",
        enabled: _page == 'cadastro',
        validator: validate(
          [],
          bundle: _bundle,
          enabled: _page == 'cadastro',
        ),
        inputFormatters: [
          services.TextInputFormatter.withFunction(
              TextFormatUtil.formatTelefone)
        ],
        onSaved: (val) => _telefone = StringUtil.unformatTelefone(val),
      ),
      secondChild: Container(),
      crossFadeState: _page == 'cadastro'
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }

  AnimatedCrossFade _buildSenha() {
    return AnimatedCrossFade(
      firstChild: new LoginInput(
        label: "login.password",
        enabled: _page == 'login',
        obscureText: true,
        validator: validate(
          [
            notEmpty(),
          ],
          bundle: _bundle,
          enabled: _page == 'login',
        ),
        onSaved: (val) => _senha = val,
      ),
      secondChild: Container(),
      crossFadeState: _page == 'login'
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }

  AnimatedCrossFade _buildOptions() {
    return AnimatedCrossFade(
      firstChild: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                padding: const EdgeInsets.all(15),
                child: comp.IntlText(
                  "login.esqueci_senha",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(
                    () {
                      _form.currentState.reset();
                      _page = 'redefinir_senha';
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FlatButton(
                padding: const EdgeInsets.all(15),
                child: comp.IntlText(
                  "login.novo_cadastro",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(
                    () {
                      _form.currentState.reset();
                      _page = 'cadastro';
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      secondChild: Container(),
      crossFadeState: _page == 'login'
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildAction() {
    return SizedBox(
      width: double.infinity,
      child: AnimatedCrossFade(
        firstChild: new LoginButton<Membro>(
          label: "login.autenticar",
          onPressed: (loading) async {
            if (_form.currentState.validate()) {
              _form.currentState.save();

              FocusScope.of(context).requestFocus(new FocusNode());

              await loading(acessoBloc.login(_email, _senha));
              Navigator.of(context).pop();
            }
          },
        ),
        secondChild: new LoginButton<dynamic>(
          label:
              _page == 'cadastro' ? "login.cadastrar" : "login.redefinir_senha",
          onPressed: (loading) async {
            if (_form.currentState.validate()) {
              _form.currentState.save();

              FocusScope.of(context).requestFocus(new FocusNode());

              if (_page == 'cadastro') {
                await loading(membroApi.cadastra(Membro(
                  nome: _nome,
                  email: _email,
                  telefones:
                      (_telefone?.isNotEmpty ?? false) ? [_telefone] : null,
                  endereco: Endereco(),
                )));

                _form.currentState.reset();

                setState(() {
                  _page = 'login';
                });

                comp.MessageHandler.success(
                  _scaffoldKey.currentState,
                  comp.IntlText(
                    "mensagens.MSG-057",
                  ),
                  duration: Duration(seconds: 8),
                );
              } else {
                await loading(acessoApi.solicitaRedefinicaoSenha(_email));

                _form.currentState.reset();

                setState(() {
                  _page = 'login';
                });

                comp.MessageHandler.success(
                  _scaffoldKey.currentState,
                  comp.IntlText("mensagens.MSG-038"),
                  duration: Duration(seconds: 8),
                );
              }
            }
          },
        ),
        crossFadeState: _page == 'login'
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class LoginButton<T> extends StatelessWidget {
  final String label;
  final comp.CommandCallback<T> onPressed;

  const LoginButton({
    Key key,
    this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return SizedBox(
      width: double.infinity,
      child: comp.CommandButton<T>(
        child: comp.IntlText(label),
        onPressed: onPressed,
        background: tema.loginButtonBackground,
        foreground: tema.loginButtonText,
      ),
    );
  }
}

class LoginInput extends StatelessWidget {
  final String label;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final bool obscureText;
  final List<services.TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;

  const LoginInput({
    Key key,
    this.label,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.obscureText = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: comp.IntlBuilder(
        text: label,
        builder: (context, label) {
          return TextFormField(
            keyboardType: keyboardType,
            onSaved: onSaved,
            validator: validator,
            cursorColor: Colors.white,
            enabled: enabled,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white54,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white54,
                ),
              ),
              errorStyle: const TextStyle(
                color: Colors.white70,
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white70),
              ),
              labelStyle: const TextStyle(color: Colors.white),
              labelText: label?.data ?? "",
            ),
          );
        },
      ),
    );
  }
}
