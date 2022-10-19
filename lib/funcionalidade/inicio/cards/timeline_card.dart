part of pocket_church.inicio;

typedef CardBuilder<T> = Widget Function(BuildContext context, T item);

class TimelineCard<T> extends StatefulWidget {
  final double height;
  final List<T> items;
  final CardBuilder<T> builder;

  TimelineCard({
    Key key,
    this.height,
    this.items,
    this.builder,
  }) : super(key: key);

  @override
  _TimelineCardState<T> createState() => _TimelineCardState<T>();
}

class _TimelineCardState<T> extends State<TimelineCard<T>>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.items.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant TimelineCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items.length != widget.items.length) {
      _tabController?.dispose();
      _tabController = TabController(length: widget.items.length, vsync: this);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: widget.items.isNotEmpty
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: widget.items.isEmpty ? Container() : _list(context, items: widget.items),
      secondChild: Container(),
    );
  }

  Widget _list(BuildContext context, {List<T> items}) {
    return Container(
      height: widget.height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              for (var item in items) _item(context, item: item),
            ],
          ),
          if (items.length <= 10)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: TabPageSelector(
                  indicatorSize: 8,
                  controller: _tabController,
                  color: Colors.white54,
                  selectedColor: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _item(BuildContext context, {T item}) {
    return ShimmerPlaceholder(
      active: item == null,
      child: widget.builder(context, item),
    );
  }
}
