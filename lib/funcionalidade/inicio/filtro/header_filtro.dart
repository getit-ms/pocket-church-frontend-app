part of pocket_church.inicio;

class HeaderFiltro extends StatelessWidget {
  final Widget title;

  const HeaderFiltro({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: DefaultTextStyle(
            child: title,
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Divider(
          color: isDark ? Colors.white54 : Colors.black54,
          height: 2,
          endIndent: 20,
          indent: 20,
        ),
      ],
    );
  }
}
