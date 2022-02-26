part of pocket_church.componentes;

class CustomHtml extends StatelessWidget {
  final String html;

  const CustomHtml({Key key, this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1,
      ),
      child: Html(
        data: html,
        defaultTextStyle: TextStyle(
          height: 2,
          color: isDark
              ? Colors.white70
              : Colors.black54,
          fontSize: 17,
        ),
        onLinkTap: LaunchUtil.site,
      ),
    );
  }
}
