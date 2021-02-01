part of pocket_church.componentes;

class InfoDivider extends StatelessWidget {
  final Widget child;

  const InfoDivider({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      width: double.infinity,
      color: tema.dividerBackground,
      padding: const EdgeInsets.all(15),
      child: DefaultTextStyle(
        style: TextStyle(
          color: tema.dividerText,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.4,
          fontSize: 16,
        ),
        child: child,
      ),
    );
  }
}
