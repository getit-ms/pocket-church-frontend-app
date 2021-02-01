part of pocket_church.componentes;

typedef AsyncLoading<T> = Future<T> Function(Future<T> future);
typedef CommandCallback<T> = void Function(AsyncLoading<T> loading);

class CommandButton<T> extends StatefulWidget {
  final Widget child;
  final CommandCallback<T> onPressed;
  final EdgeInsetsGeometry padding;
  final Color background;
  final Color foreground;
  final ShapeBorder shape;
  final TextStyle textStyle;

  const CommandButton({
    Key key,
    this.child,
    this.shape,
    this.padding,
    this.onPressed,
    this.background,
    this.textStyle,
    this.foreground,
  }) : super(key: key);

  @override
  _CommandButtonState<T> createState() => _CommandButtonState<T>();
}

class _CommandButtonState<T> extends State<CommandButton<T>> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return RawMaterialButton(
      shape: widget.shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      padding: widget.padding ?? const EdgeInsets.all(15),
      fillColor: widget.onPressed == null || _loading
          ? (widget.background ?? tema.buttonBackground).withOpacity(.5)
          : widget.background ?? tema.buttonBackground,
      child: _loading
          ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.foreground ?? tema.buttonText,
                ),
              ),
            )
          : DefaultTextStyle(
              child: widget.child,
              style: widget.textStyle ?? TextStyle(color: widget.foreground ?? tema.buttonText),
            ),
      onPressed:
          widget.onPressed == null || _loading ? null : _processCommand,
    );
  }

  _processCommand() async {
    widget.onPressed(_processLoading);
  }

  Future<T> _processLoading(Future<T> future) async {
    setState(() {
      _loading = true;
    });

    try {
      return await future;
    } catch (ex) {
      error.handle(Scaffold.of(context), ex);

      throw ex;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
