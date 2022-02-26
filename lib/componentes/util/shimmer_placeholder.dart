part of pocket_church.componentes;

class ShimmerPlaceholder extends StatelessWidget {
  final Widget child;
  final bool active;

  const ShimmerPlaceholder({Key key, this.active, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (active) {
      bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
      return Shimmer.fromColors(
        child: child,
        baseColor: isDark ? Colors.white12 : Colors.grey[300],
        highlightColor: isDark ? Colors.white24 : Colors.grey[100],
      );
    }

    return child;
  }
}
