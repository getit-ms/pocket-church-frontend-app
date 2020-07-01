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
        data: "<div>" + html + "</div>",
        style: {
          'div': Style(
            color: Colors.black54,
            fontSize: FontSize(17),
          ),
        },
        onLinkTap: (link) {
          LaunchUtil.site(link);
        },
      ),
    );
  }
}
