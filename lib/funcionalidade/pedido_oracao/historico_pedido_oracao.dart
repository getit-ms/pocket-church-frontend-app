part of pocket_church.pedido_oracao;

class HistoricoPedidoOracao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return FutureBuilder<Pagina<PedidoOracao>>(
      future: pedidoOracaoApi.consultaMeus(
        pagina: 1,
        tamanhoPagina: 50,
      ),
      builder: (context, snapshot) {
        if (snapshot.data?.resultados?.isNotEmpty ?? false) {
          return Column(
            children: <Widget>[
              InfoDivider(
                child: const IntlText("oracao.ultimos_pedidos"),
              ),
              for (PedidoOracao pedido in snapshot.data.resultados)
                _buildPedido(context, pedido, tema),
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _buildPedido(BuildContext context, PedidoOracao pedido, Tema tema) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDark ? Colors.grey[900] : Colors.white,
      child: ListTile(
        title: Text(
          pedido.pedido,
          style: TextStyle(
            color: tema.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: pedido.dataAtendimento != null
            ? IntlText(
                "oracao.atendido",
                style: TextStyle(
                  color: tema.primary,
                ),
              )
            : const IntlText(
                "oracao.pendente",
              ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(pedido.nome + " - " + pedido.email),
            IntlBuilder(
              text: "oracao.data_pedido",
              builder: (context, snapshot) {
                return Text(
                    "${snapshot.data ?? ""}: ${StringUtil.formatData(pedido.dataSolicitacao, pattern: "dd MMMM yyyy")}");
              },
            ),
            pedido.dataAtendimento != null
                ? IntlBuilder(
                    text: "oracao.data_atendimento",
                    builder: (context, snapshot) {
                      return Text(
                          "${snapshot.data ?? ""}: ${StringUtil.formatData(pedido.dataAtendimento, pattern: "dd MMMM yyyy")}");
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
