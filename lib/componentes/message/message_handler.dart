part of pocket_church.componentes;

class MessageHandler {
  static info(ScaffoldState scaffoldState, Widget message, {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.info_outline, Colors.lightBlueAccent, message);
  }

  static success(ScaffoldState scaffoldState, Widget message, {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.check_circle_outline, Colors.lightGreenAccent, message);
  }

  static warn(ScaffoldState scaffoldState, Widget message, {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.warning, Colors.orangeAccent, message);
  }

  static error(ScaffoldState scaffoldState, Widget message, {Duration duration = const Duration(seconds: 3)}) {
    _add(scaffoldState, Icons.error_outline, Colors.redAccent, message);
  }

  static void _add(ScaffoldState scaffoldState, IconData icon, Color color, Widget message, {Duration duration = const Duration(seconds: 3)}) {
    scaffoldState.showSnackBar(new SnackBar(
      duration: duration,
      content: Row(
        children: <Widget>[
          Icon(icon,
            color: color,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: message,
          ),
        ],
      ),
    ));
  }
}
