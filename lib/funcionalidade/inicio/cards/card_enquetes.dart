part of pocket_church.inicio;

class CardEnquetes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (acessoBloc.temAcesso(Funcionalidade.REALIZAR_VOTACAO)) {
      return StreamBuilder<List<Enquete>>(
        stream: institucionalBloc.enquetes,
        initialData: institucionalBloc.currentEnquetes,
        builder: (context, snapshot) {
          return TimelineCard(
            height: 250,
            builder: _buildEnquete,
            items: snapshot.data ?? [null, null, null],
          );
        },
      );
    }

    return Container();
  }

  Widget _buildEnquete(BuildContext context, Enquete enquete) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(20),
      child: enquete != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  enquete.nome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: tema.primary,
                    fontSize: 22,
                  ),
                ),
                Text(
                  enquete.descricao,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IntlText(
                    "enquete.disponivel_ate_prazo",
                    args: {
                      'prazo': StringUtil.formatData(enquete.dataTermino),
                    },
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ),
                Center(
                  child: ButtonEnquete(
                    enquete: enquete,
                    onRespondido: () {
                      institucionalBloc.loadEnquetes();
                    },
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
