part of pocket_church.enquete;

class ButtonEnquete extends StatelessWidget {
  final Enquete enquete;
  final VoidCallback onRespondido;

  const ButtonEnquete({
    Key key,
    this.enquete,
    this.onRespondido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enquete.encerrado) {
      return CommandButton(
        child: const IntlText("enquete.resultado"),
        onPressed: (loading) async {
          await NavigatorUtil.navigate(
            context,
            builder: (context) => PageResultadoEnquete(
              enquete: enquete,
            ),
          );
        },
      );
    }
    return CommandButton(
      child: enquete.respondido
          ? const IntlText("enquete.respondida")
          : const IntlText("enquete.responder"),
      onPressed: enquete.respondido
          ? null
          : (loading) async {
              await NavigatorUtil.navigate(
                context,
                builder: (context) => PageRespostaEnquete(
                  enquete: enquete,
                ),
              );

              if (onRespondido != null) {
                onRespondido();
              }
            },
    );
  }
}
