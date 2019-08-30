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

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: IntlText(
                "chamado.enunciado",
                args: {
                  'nomeAplicativo':
                      ConfiguracaoApp.of(context).config.nomeAplicativo,
                },
                textAlign: TextAlign.left,
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
            InfoDivider(child: IntlText("chamado.tipo.tipo"),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InputChip(
                  label: IntlText("chamado.tipo.SUGESTAO"),
                  onPressed: () => setState(() => _sugestao.tipo = 'SUGESTAO'),
                  selected: _sugestao.tipo == 'SUGESTAO',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                InputChip(
                  label: IntlText("chamado.tipo.ERRO"),
                  onPressed: () => setState(() => _sugestao.tipo = 'ERRO'),
                  selected: _sugestao.tipo == 'ERRO',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                InputChip(
                  label: IntlText("chamado.tipo.RECLAMACAO"),
                  onPressed: () => setState(() => _sugestao.tipo = 'RECLAMACAO'),
                  selected: _sugestao.tipo == 'RECLAMACAO',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  padding: const EdgeInsets.all(10),
                ),
              ],
            ),
            InfoDivider(child: IntlText("chamado.tipo.tipo"),),
            TextFormField(
              validator: validate([
                notEmpty(),
                length(max: 500),
              ], bundle: bundle),
              maxLines: 5,
              maxLength: 500,
              onSaved: (val) => _sugestao.descricao = val,
              decoration: InputDecoration(
                labelText: bundle["chamado.descricao"],
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
