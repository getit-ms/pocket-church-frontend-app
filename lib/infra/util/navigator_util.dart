part of pocket_church.infra;

class NavigatorUtil {

  static Map<String, WidgetBuilder> _routes = Map();

  static init(Map<String, WidgetBuilder> routes) {
    _routes = routes;
  }

  static Future<T> navigate<T>(BuildContext context,
      {WidgetBuilder builder, String named, bool replace = false}) {

    if (named != null) {
      builder = _routes[named];
    }

    if (builder == null) {
      throw Exception("Rota não encontrada: " + named);
    }

    if (replace) {
      return Navigator.of(context).pushReplacement(
          CupertinoPageRoute<T>(builder: (context) => builder(context))
      );
    } else {
      return Navigator.of(context).push(
          CupertinoPageRoute<T>(builder: (context) => builder(context))
      );
    }
  }

  static confirma(BuildContext context, {Widget title, Widget message}) async {
    bool confirmado = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: message,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
            Navigator.of(context).pop(true);
          },
            child: IntlText("global.sim"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: IntlText("global.nao"),
          ),
        ],
      ),
    );

    return confirmado ?? false;
  }

}
