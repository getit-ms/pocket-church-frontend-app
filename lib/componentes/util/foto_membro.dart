part of pocket_church.componentes;

class FotoMembro extends StatelessWidget {
  final Arquivo foto;
  final double size;
  final Color color;
  final ImageProvider placeholder;

  const FotoMembro(
    this.foto, {
    this.size,
    this.color,
    this.placeholder = const AssetImage("assets/imgs/avatar.png"),
  });

  @override
  Widget build(BuildContext context) {
    if (foto == null) {
      return Container(
        width: size,
        height: size,
        color: color,
        child: Image(
          image: placeholder,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        color: color,
        child: FadeInImage(
          placeholder: placeholder,
          image: ArquivoImageProvider(foto.id),
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
