// Imports the Flutter Driver API.
import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart' as drv;
import 'package:screenshots/screenshots.dart';
import 'package:vm_service_client/vm_service_client.dart';
import 'package:test/test.dart';

void main() async {

  group('Prints', () {
    drv.FlutterDriver driver;
    VM vm;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await drv.FlutterDriver.connect();
      vm = await driver.serviceClient.getVM();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    final config = Config();

    test('print home', () async {
      await Future.delayed(const Duration(seconds: 10), () => {});

      // Aguarda o splash carregar
      for (final isolateRef in vm.isolates) {
        final isolate = await isolateRef.load();
        if (isolate.isPaused) {
          isolate.resume();
        }
      }

      print('iniciando navegação...');

      drv.SerializableFinder tabViewApresentacao = drv.find.byValueKey('tab_view_apresentacao');

      await Future.delayed(const Duration(seconds: 5), () => {});

      print('passando para aba 2...');
      // Passa pra segunda tab
      await driver.scroll(
          tabViewApresentacao, -300, 0, const Duration(milliseconds: 500));

      print('passando para aba 3...');
      // Passa pra terceira tab
      await driver.scroll(
          tabViewApresentacao, -300, 0, const Duration(milliseconds: 500));

      final opcaoReativa = drv.find.byValueKey("opcao_reativa");

      print('clicando na opção de reativo...');
      await driver.tap(opcaoReativa);

      final sliverList = drv.find.byValueKey("sliver_list_home");

      await screenshot(driver, config, 'screen1');

      final opcaoMenu = drv.find.byValueKey("opcao_menu");

      print("clicando na opção de menu...");

      await driver.tap(opcaoMenu);

      final tabMais = drv.find.byValueKey("tab_mais");

      await screenshot(driver, config, 'screen2');

      final opcaoInstitucional = drv.find.byValueKey("opcao_institucional");

      await driver.tap(opcaoInstitucional);

      final pageInstitucional = drv.find.byValueKey("page_institucional");

      await screenshot(driver, config, 'screen3');

      final voltar = drv.find.byType("BackButton");

      await driver.tap(voltar);

      final iconUsuario = drv.find.byValueKey("icon_usuario");

      await driver.tap(iconUsuario);

      final pageLogin = drv.find.byValueKey("page_login");

      await screenshot(driver, config, 'screen4');

      await Future.delayed(const Duration(seconds: 5), () => {});
    }, timeout: Timeout(Duration(minutes: 2)));
  });
}
