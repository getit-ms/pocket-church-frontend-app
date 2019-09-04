import 'package:flutter_driver/driver_extension.dart';
import 'package:pocket_church/main.dart' as app;
import 'package:pocket_church/infra/infra.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  print('atualizando bundle...');
  configuracaoBloc.init().then(() {
    configuracaoBloc.refreshBundle();
  });

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();
}