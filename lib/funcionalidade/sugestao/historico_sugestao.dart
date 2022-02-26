part of pocket_church.sugestao;

class HistoricoSugestao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDark ? Colors.grey[900] : Colors.white,
      child: FutureBuilder<Pagina<Sugestao>>(
        future: chamadoApi.consultaMeus(
          pagina: 1,
          tamanhoPagina: 50,
        ),
        builder: (context, snapshot) {
          if (snapshot.data?.resultados?.isNotEmpty ?? false) {
            return Column(
              children: <Widget>[
                InfoDivider(
                  child: const IntlText("chamado.chamados"),
                ),
              ]
                  .followedBy(snapshot.data.resultados
                      .map((pedido) => _buildSugestao(pedido, tema)))
                  .toList(),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildSugestao(Sugestao sugestao, Tema tema) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IntlText(
                  "chamado.tipo." + sugestao.tipo,
                  style: TextStyle(
                    color: tema.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("\"${sugestao.descricao}\"",
                    style: TextStyle(
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                labelValor(
                  label: const IntlText("chamado.solicitacao"),
                  valor: Text(StringUtil.formatData(sugestao.dataSolicitacao,
                      pattern: "dd MMMM yyyy HH:mm")),
                ),
                sugestao.dataResposta != null
                    ? labelValor(
                        label: const IntlText("chamado.atendimento"),
                        valor: Text(StringUtil.formatData(sugestao.dataResposta,
                            pattern: "dd MMMM yyyy HH:mm")),
                      )
                    : Container(),
              ],
            ),
          ),
          IntlText("chamado.status." + (sugestao.status ?? 'NOVO')),
        ],
      ),
    );
  }

  Widget labelValor({Widget label, Widget valor}) {
    return Row(
      children: <Widget>[
        label,
        const Text(":"),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: valor,
        ),
      ],
    );
  }
}
