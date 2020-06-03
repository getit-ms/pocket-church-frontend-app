import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:pocket_church/main.dart' as app;

void main() async {
  // This line enables the extension.
  enableFlutterDriverExtension();

  await rootBundle.loadString("assets/bundle/pt-br.json");

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();
}
