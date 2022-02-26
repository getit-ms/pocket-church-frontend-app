part of pocket_church.sugestao;

class FormSugestao extends StatefulWidget {
  @override
  _FormSugestaoState createState() => _FormSugestaoState();
}

class _FormSugestaoState extends State<FormSugestao> {
  GlobalKey<FormState> _form = new GlobalKey();

  bool _autenticado = false;

  Sugestao _sugestao = new Sugestao(
    dataSolicitacao: DateTime.now(),
    tipo: 'SUGESTAO',
    status: 'NOVO',
  );

  TextEditingController _nome = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _carregaDadosPadroes();
  }

  _carregaDadosPadroes() async {
    bool autenticado = acessoBloc.autenticado;

    if (autenticado) {
      Membro membro = acessoBloc.currentMembro;

      setState(() {
        _autenticado = true;
        _nome.text = membro.nome;
        _email.text = membro.email;
      });
    } else {
      setState(() {
        this._autenticado = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Bundle bundle = ConfiguracaoApp.of(context).bundle;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? Colors.grey[900] : Colors.transparent,
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: IntlText(
                "chamado.enunciado",
                args: {
                  'nomeAplicativo':
                      ConfiguracaoApp.of(context).config.nomeAplicativo,
                },
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const InfoDivider(
              child: IntlText("chamado.solicitante"),
            ),
            TextFormField(
              validator: validate([
                notEmpty(),
                length(max: 150),
              ], bundle: bundle),
              controller: _nome,
              enabled: !_autenticado,
              onSaved: (val) => _sugestao.nomeSolicitante = val,
              decoration: InputDecoration(
                labelText: bundle["chamado.nome_solicitante"],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
              ),
            ),
            TextFormField(
              validator: validate([
                notEmpty(),
                email(),
                length(max: 150),
              ], bundle: bundle),
              controller: _email,
              enabled: !_autenticado,
              onSaved: (val) => _sugestao.emailSolicitante = val,
              decoration: InputDecoration(
                labelText: bundle["chamado.email_solicitante"],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
              ),
            ),
            const InfoDivider(
              child: IntlText("chamado.tipo.tipo"),
            ),
            SelectOpcao<String>(
              value: _sugestao.tipo,
              onSaved: (tipo) => setState(() {
                _sugestao.tipo = tipo;
              }),
              opcoes: [
                Opcao(
                  intlLabel: "chamado.tipo.SUGESTAO",
                  valor: "SUGESTAO"
                ),
                Opcao(
                    intlLabel: "chamado.tipo.ERRO",
                    valor: "ERRO"
                ),
                Opcao(
                    intlLabel: "chamado.tipo.RECLAMACAO",
                    valor: "RECLAMACAO"
                ),
              ],
            ),
            const InfoDivider(
              child: IntlText("chamado.descricao"),
            ),
            TextFormField(
              validator: validate([
                notEmpty(),
                length(max: 500),
              ], bundle: bundle),
              maxLines: 5,
              maxLength: 500,
              onSaved: (val) => _sugestao.descricao = val,
              decoration: InputDecoration(
                hintText: bundle['chamado.descricao_explicacao'],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: CommandButton<Sugestao>(
                child: IntlText("chamado.submeter"),
                onPressed: (loading) async {
                  if (_form.currentState.validate()) {
                    _form.currentState.save();

                    await loading(chamadoApi.cadastra(_sugestao));

                    _form.currentState.reset();

                    MessageHandler.success(
                      Scaffold.of(context),
                      const IntlText("mensagens.MSG-001"),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

