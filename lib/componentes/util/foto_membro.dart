part of pocket_church.componentes;

class FotoMembro extends StatelessWidget {
  final Arquivo foto;
  final double size;
  final Color color;
  final ImageProvider placeholder;
  final Color foreground;

  const FotoMembro(
    this.foto, {
    this.size,
    this.color,
    this.foreground,
    this.placeholder = const AssetImage("assets/imgs/avatar.png"),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: color,
      child: Stack(
        children: [
          Image(
            image: placeholder,
            fit: BoxFit.contain,
            color: foreground,
            width: size,
            height: size,
          ),
          Positioned.fill(
            child: foto != null
                ? FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: ArquivoImageProvider(foto.id),
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
