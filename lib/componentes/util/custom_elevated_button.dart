part of pocket_church.componentes;

class CustomElevatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    this.child,
    this.onPressed,
  });

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _elevation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() => setState(() {}));
    _elevation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) {
        setState(() {
          _animationController.forward();
        });
      } : null,
      onTapCancel: widget.onPressed != null ? () {
        setState(() {
          _animationController.reverse();
        });
      } : null,
      onTapUp: widget.onPressed != null ? (_) {
        widget.onPressed();
        setState(() {
          _animationController.reverse();
        });
      } : null,
      child: Transform.scale(
        scale: lerpDouble(1, .975, _elevation.value),
        child: Opacity(
          opacity: lerpDouble(1, .85, _elevation.value),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Color.lerp(
                      Colors.black26, Colors.black12, _elevation.value),
                  blurRadius: lerpDouble(15, 1, _elevation.value),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: new BorderRadius.all(Radius.circular(15)),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
