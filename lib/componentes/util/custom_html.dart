part of pocket_church.componentes;

class CustomHtml extends StatelessWidget {
  final String html;

  const CustomHtml({Key key, this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1,
      ),
      child: Html(
        data: html,
        defaultTextStyle: TextStyle(
          height: 1.6,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        onLinkTap: LaunchUtil.site,
      ),
    );
  }
}
