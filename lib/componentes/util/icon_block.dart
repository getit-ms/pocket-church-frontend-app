part of pocket_church.componentes;

class IconBlock extends StatelessWidget {
  final IconData icon;

  const IconBlock(this.icon);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: tema.iconBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 3
          )
        ],
      ),
      child: Icon(
        icon,
        color: tema.iconForeground,
      ),
    );
  }
}
