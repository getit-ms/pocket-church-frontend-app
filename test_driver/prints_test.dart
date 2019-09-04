
// Imports the Flutter Driver API.
import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

void main() {
  group('Prints', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    final config = Config();

    test('print home', () async {
      // Aguarda o splash carregar
      print('aguardando...');
      await Future.delayed(const Duration(seconds: 5), () => {});

      final tabViewApresentacao = find.byValueKey('tab_view_apresentacao');

      print('passando para aba 2...');
      // Passa pra segunda tab
      await driver.scroll(tabViewApresentacao, -300, 0, const Duration(milliseconds: 500));

      print('passando para aba 3...');
      // Passa pra terceira tab
      await driver.scroll(tabViewApresentacao, -300, 0, const Duration(milliseconds: 500));

      final opcaoReativa = find.byValueKey("opcao_reativa");

      print('clicando na opção de reativo...');
      await driver.tap(opcaoReativa);

      final sliverList = find.byValueKey("sliver_list_home");

      await screenshot(driver, config, 'myscreenshot1');

      await Future.delayed(const Duration(seconds: 5), () => {});
    });
  });
}