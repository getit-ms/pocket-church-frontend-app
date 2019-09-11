part of pocket_church.evento;

class PageInscricaoEvento extends StatefulWidget {
  final Evento evento;

  const PageInscricaoEvento({this.evento});

  @override
  _PageInscricaoEventoState createState() => _PageInscricaoEventoState();
}

class _PageInscricaoEventoState extends State<PageInscricaoEvento> {
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
      deveEstarAutenticado: true,
      title: const IntlText("evento.inscricao"),
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
                    widget.evento.nome,
                    style: TextStyle(
                      color: tema.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
                ItemEvento(
                  label: const IntlText("evento.vagas"),
                  value: Text(widget.evento.vagasRestantes.toString()),
                ),
              ]
                  .followedBy(
                      _inscricoes.map<Widget>((inscricao) => FormInscricao(
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
                    widget.evento.vagasRestantes - _inscricoes.length > 0
                        ? [_buildAddButton(tema)]
                        : [],
                  )
                  .followedBy([
                const InfoDivider(
                  child: const IntlText("evento.concluir_inscricao"),
                ),
                ItemEvento(
                  label: const IntlText("evento.total_inscricoes"),
                  value: Text(_inscricoes.length.toString()),
                ),
                widget.evento.exigePagamento
                    ? ItemEvento(
                        label: const IntlText("evento.valor_total"),
                        value: Text(
                          StringUtil.formataCurrency(
                            (widget.evento.valor ?? 0) * _inscricoes.length),
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
        child: const IntlText("evento.concluir_inscricao"),
        onPressed: (loading) async {
          if (_form.currentState.validate()) {
            _form.currentState.save();

            ResultadoInscricao resultado =
                await loading(eventoApi.realizaInscricao(
              widget.evento.id,
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
              "evento.adicionar_inscrito",
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

    setState(() {
      _inscricoes[0].nomeInscrito = membro.nome;
      _inscricoes[0].emailInscrito = membro.email;
      if (membro.telefones != null) {
        _inscricoes[0].telefoneInscrito = membro.telefones[0];
      }
    });
  }
}

class FormInscricao extends StatefulWidget {
  final InscricaoEvento inscricao;
  final VoidCallback onRemove;

  const FormInscricao(this.inscricao, {this.onRemove});

  @override
  _FormInscricaoState createState() => _FormInscricaoState();
}

class _FormInscricaoState extends State<FormInscricao> {
  TextEditingController _nome;
  TextEditingController _email;
  TextEditingController _telefone;

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
              IntlText("evento.inscrito"),
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
        new TypeAheadFormField<Membro>(
          noItemsFoundBuilder: (context) => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const IntlText(
              "global.nenhum_registro_encontrado",
              textAlign: TextAlign.center,
            ),
          ),
          autoFlipDirection: true,
          validator: validate([
            notEmpty(),
            length(max: 150),
          ], bundle: bundle),
          onSaved: (val) => widget.inscricao.nomeInscrito = val,
          suggestionsCallback: (filtro) async {
            Pagina<Membro> resultado = await membroApi.consulta(
              filtro: filtro,
              tamanhoPagina: 5,
            );
            return resultado.resultados ?? [];
          },
          onSuggestionSelected: (membro) async {
            _nome.text = membro.nome;
            _email.text = membro.email;

            Membro detalhes = await membroApi.detalha(membro.id);

            if (detalhes.telefones?.isNotEmpty ?? false) {
              _telefone.text = StringUtil.formatTelefone(detalhes.telefones[0]);
            }
          },
          itemBuilder: (context, membro) {
            return Material(
              color: Colors.white,
              child: ListTile(
                leading: FotoMembro(
                  membro.foto,
                  size: 50,
                ),
                title: Text(membro.nome),
                subtitle: Text(membro.email ?? ""),
              ),
            );
          },
          textFieldConfiguration: TextFieldConfiguration(
            controller: _nome,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              labelText: bundle["evento.nome"],
            ),
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
            labelText: bundle["evento.email"],
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
          onSaved: (val) => widget.inscricao.telefoneInscrito =
              StringUtil.unformatTelefone(val),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            labelText: bundle["evento.telefone"],
          ),
        ),
      ],
    );
  }
}
