part of pocket_church.pedido_oracao;

class FormPedidoOracao extends StatefulWidget {
  @override
  _FormPedidoOracaoState createState() => _FormPedidoOracaoState();
}

class _FormPedidoOracaoState extends State<FormPedidoOracao> {
  GlobalKey<FormState> _form = new GlobalKey();

  PedidoOracao _pedidoOracao = new PedidoOracao(
    dataSolicitacao: DateTime.now(),
  );

  TextEditingController _nome = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _nome.text = acessoBloc.currentMembro.nome;
    _email.text = acessoBloc.currentMembro.email;
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
            InfoDivider(
              child: const IntlText("oracao.pedido"),
            ),
            TextFormField(
              validator: validate([
                notEmpty(),
                length(max: 150),
              ], bundle: bundle),
              controller: _nome,
              onSaved: (val) => _pedidoOracao.nome = val,
              decoration: InputDecoration(
                labelText: bundle["oracao.nome"],
                contentPadding: EdgeInsets.symmetric(
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
              onSaved: (val) => _pedidoOracao.email = val,
              decoration: InputDecoration(
                labelText: bundle["oracao.email"],
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
              ),
            ),
            TextFormField(
              validator: validate([
                notEmpty(),
              ], bundle: bundle),
              maxLength: 500,
              maxLines: 5,
              onSaved: (val) => _pedidoOracao.pedido = val,
              decoration: InputDecoration(
                hintText: bundle["oracao.pedido"],
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: CommandButton<PedidoOracao>(
                child: IntlText("oracao.submeter"),
                onPressed: (loading) async {
                  if (_form.currentState.validate()) {
                    _form.currentState.save();

                    await loading(pedidoOracaoApi.submete(_pedidoOracao));

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
