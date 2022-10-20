part of pocket_church.componentes;

class MessageHandler {
  static info(ScaffoldState scaffoldState, Widget message,
      {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.info_outline, Colors.lightBlueAccent,
        Colors.blue[100], message);
  }

  static success(ScaffoldState scaffoldState, Widget message,
      {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.check_circle_outline, Colors.lightGreenAccent,
        Colors.green[100], message);
  }

  static warn(ScaffoldState scaffoldState, Widget message,
      {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.warning, Colors.orangeAccent, Colors.orange[100],
        message);
  }

  static error(ScaffoldState scaffoldState, Widget message,
      {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.error_outline, Colors.redAccent, Colors.red[100],
        message);
  }

  static void _add(ScaffoldState scaffoldState, IconData icon, Color foreground,
      Color background, Widget message,
      {Duration duration = const Duration(seconds: 3)}) {
    scaffoldState.showSnackBar(new SnackBar(
      duration: duration,
      backgroundColor: background,
      content: Row(
        children: <Widget>[
          Icon(icon, color: Colors.black54),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              child: message,
            ),
          ),
        ],
      ),
    ));
  }
}
