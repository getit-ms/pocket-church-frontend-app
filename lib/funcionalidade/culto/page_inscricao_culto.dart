part of pocket_church.culto;

class PageInscricaoCulto extends StatefulWidget {
  final Evento culto;

  const PageInscricaoCulto({this.culto});

  @override
  _PageInscricaoCultoState createState() => _PageInscricaoCultoState();
}

class _PageInscricaoCultoState extends State<PageInscricaoCulto> {
  List<InscricaoEvento> _inscricoes = [InscricaoEvento()];

  GlobalKey<FormState> _form = new GlobalKey();

  @override
  void initState() {
    super.initState();

    _preparaInscricao();
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      title: const IntlText("culto.inscricao"),
      body: Container(
        color: Colors.white,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    widget.culto.nome,
                    style: TextStyle(
                      color: tema.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
                ItemCulto(
                  label: const IntlText("culto.vagas"),
                  value: Text(widget.culto.vagasRestantes.toString()),
                ),
              ]
                  .followedBy(
                      _inscricoes.map<Widget>((inscricao) => FormInscricao(
                            widget.culto,
                            inscricao,
                            onRemove: _inscricoes.length > 1
                                ? () {
                                    setState(() {
                                      _inscricoes.remove(inscricao);
                                    });
                                  }
                                : null,
                          )))
                  .followedBy(
                    widget.culto.vagasRestantes - _inscricoes.length > 0
                        ? [_buildAddButton(tema)]
                        : [],
                  )
                  .followedBy([
                const InfoDivider(
                  child: const IntlText("culto.concluir_inscricao"),
                ),
                ItemCulto(
                  label: const IntlText("culto.total_inscricoes"),
                  value: Text(_inscricoes.length.toString()),
                ),
                widget.culto.exigePagamento
                    ? ItemCulto(
                        label: const IntlText("culto.valor_total"),
                        value: Text(
                          StringUtil.formataCurrency(
                              (widget.culto.valor ?? 0) * _inscricoes.length),
                        ),
                      )
                    : Container(),
                _buildConcluirButton(context, tema),
              ]).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildConcluirButton(BuildContext context, Tema tema) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: CommandButton<ResultadoInscricao>(
        child: const IntlText("culto.concluir_inscricao"),
        onPressed: (loading) async {
          if (_form.currentState.validate()) {
            _form.currentState.save();

            ResultadoInscricao resultado =
                await loading(eventoApi.realizaInscricao(
              widget.culto.id,
              inscricoes: _inscricoes,
            ));

            Navigator.of(context).pop();

            if (resultado.devePagar) {
              await showCupertinoModalPopup(
                context: context,
                builder: (context) => AlertDialog(
                  title: const IntlText("global.title.200"),
                  content: const IntlText("mensagens.MSG-042"),
                  actions: <Widget>[
                    const CupertinoDialogAction(
                      child: const IntlText("global.ok"),
                    )
                  ],
                ),
              );

              LaunchUtil.site(
                  "https://pagseguro.uol.com.br/v2/checkout/payment.html?code=${resultado.checkoutPagSeguro}");
            } else {
              MessageHandler.success(
                Scaffold.of(context),
                const IntlText("mensagens.MSG-001"),
              );
            }
          }
        },
      ),
    );
  }

  Container _buildAddButton(Tema tema) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: RawMaterialButton(
        fillColor: tema.buttonBackground,
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        onPressed: () {
          setState(() {
            _inscricoes.add(InscricaoEvento());
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_circle),
            const SizedBox(
              width: 5,
            ),
            IntlText(
              "culto.adicionar_inscrito",
              style: TextStyle(
                color: tema.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _preparaInscricao() async {
    Membro membro = acessoBloc.currentMembro;

    if (membro != null) {
      setState(() {
        _inscricoes[0].nomeInscrito = membro.nome;
        _inscricoes[0].emailInscrito = membro.email;
        if (membro.telefones != null) {
          _inscricoes[0].telefoneInscrito = membro.telefones[0];
        }
      });
    }
  }
}

class FormInscricao extends StatefulWidget {
  final Evento culto;
  final InscricaoEvento inscricao;
  final VoidCallback onRemove;

  const FormInscricao(this.culto, this.inscricao, {this.onRemove});

  @override
  _FormInscricaoState createState() => _FormInscricaoState();
}

class _FormInscricaoState extends State<FormInscricao> {
  TextEditingController _nome;
  TextEditingController _email;
  TextEditingController _telefone;

  Map<CampoEvento, ValorInscricaoEvento> valores = {};

  @override
  void initState() {
    super.initState();

    _nome = new TextEditingController(
      text: widget.inscricao.nomeInscrito ?? "",
    );
    _email = new TextEditingController(
      text: widget.inscricao.emailInscrito ?? "",
    );
    _telefone = new TextEditingController(
      text: StringUtil.formatTelefone(widget.inscricao.telefoneInscrito ?? ""),
    );

    if (widget.culto.campos != null) {
      widget.inscricao.valores = [];

      for (CampoEvento campo in widget.culto.campos) {
        var valorInscricaoEvento = ValorInscricaoEvento(nome: campo.nome, formato: campo.formato);
        widget.inscricao.valores.add(valorInscricaoEvento);
        valores[campo] = valorInscricaoEvento;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    Bundle bundle = ConfiguracaoApp.of(context).bundle;

    return Column(
      children: <Widget>[
        InfoDivider(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IntlText("culto.inscrito"),
              widget.onRemove != null
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onRemove,
                        child: Icon(
                          Icons.delete,
                          color: tema.dividerText,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        new TextFormField(
          validator: validate([
            notEmpty(),
            length(max: 150),
          ], bundle: bundle),
          onSaved: (val) => widget.inscricao.nomeInscrito = val,
          controller: _nome,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            labelText: bundle["culto.nome"],
          ),
        ),
        TextFormField(
          controller: _email,
          validator: validate([
            notEmpty(),
            email(),
            length(max: 150),
          ], bundle: bundle),
          onSaved: (val) => widget.inscricao.emailInscrito = val,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            labelText: bundle["culto.email"],
          ),
        ),
        TextFormField(
          controller: _telefone,
          keyboardType: TextInputType.phone,
          validator: validate([
            notEmpty(),
            length(max: 20),
          ], bundle: bundle),
          inputFormatters: [
            services.TextInputFormatter.withFunction(
                TextFormatUtil.formatTelefone)
          ],
          onSaved: (val) =>
              widget.inscricao.telefoneInscrito = StringUtil.unformat(val),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            labelText: bundle["culto.telefone"],
          ),
        ),
        for (CampoEvento campo in widget.culto.campos ?? [])
          InputCampoEvento(campo: campo, valor: valores[campo]),
      ],
    );
  }
}

