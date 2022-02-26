part of pocket_church.inicio;

class AcaoItemEvento extends StatelessWidget {
  final int count;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  const AcaoItemEvento({
    Key key,
    this.count = 0,
    this.icon,
    this.iconColor,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return RawMaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      constraints: BoxConstraints(minWidth: 0),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          const SizedBox(width: 10),
          if (text != null) IntlText(text),
          if (text == null) Text(StringUtil.formatCount(count)),
        ],
      ),
    );
  }
}

class AcaoToggleLike extends StatefulWidget {
  final ItemEvento item;
  final bool enabled;

  const AcaoToggleLike({
    Key key,
    this.item,
    this.enabled = true,
  }) : super(key: key);

  @override
  _AcaoToggleLikeState createState() => _AcaoToggleLikeState();
}

class _AcaoToggleLikeState extends State<AcaoToggleLike> {
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return AcaoItemEvento(
      onPressed: widget.item == null || !widget.enabled
          ? null
          : () {
              _timer?.cancel();
              if (widget.item.curtido) {
                setState(() {
                  widget.item.curtido = false;
                  widget.item.quantidadeCurtidas--;
                });
                _timer = new Timer(Duration(milliseconds: 500), () async {
                  await itemEventoApi.dislike(widget.item.tipo, widget.item.id);
                });
              } else {
                setState(() {
                  widget.item.curtido = true;
                  widget.item.quantidadeCurtidas++;
                });
                _timer = new Timer(Duration(milliseconds: 500), () async {
                  await itemEventoApi.like(widget.item.tipo, widget.item.id);
                });
              }
            },
      icon: (widget.item?.curtido ?? false)
          ? FontAwesomeIcons.solidHeart
          : FontAwesomeIcons.heart,
      iconColor: (widget.item?.curtido ?? false) ? tema.primary : null,
      count: widget.item?.quantidadeCurtidas ?? 0,
    );
  }
}
