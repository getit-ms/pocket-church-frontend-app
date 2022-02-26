part of pocket_church.componentes;

class WidgetBody extends StatefulWidget {
  final Widget title;
  final VoidCallback onMore;
  final Widget body;

  const WidgetBody({this.title, this.onMore, this.body});

  @override
  _WidgetBodyState createState() => _WidgetBodyState();
}

class _WidgetBodyState extends State<WidgetBody> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Container(
        child: Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.white54 : Colors.black54,
                      width: .5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 22,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          child: widget.title,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RawMaterialButton(
                      padding: const EdgeInsets.all(0),
                      child: const IntlText("global.mais"),
                      onPressed: widget.onMore,
                    )
                  ],
                ),
              ),
              widget.body
            ],
          ),
        ),
      ),
    );
  }
}
