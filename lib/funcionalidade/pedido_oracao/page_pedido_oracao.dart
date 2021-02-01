part of pocket_church.pedido_oracao;

class PagePedidoOracao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("oracao.oracoes"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormPedidoOracao(),
            HistoricoPedidoOracao(),
          ],
        ),
      ),
    );
  }
}
