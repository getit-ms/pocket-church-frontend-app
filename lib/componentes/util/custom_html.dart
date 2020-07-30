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
      child: HtmlWidget(
        html,
        textStyle: TextStyle(
          fontSize: 17,
          color: Colors.black54,
        ),
        onTapUrl: (link) {
          LaunchUtil.site(link);
        },
      ),
    );
  }
}
