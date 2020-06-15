import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ipamericas",
  nomeAplicativo: "IPR",
  nomeIgreja: "Igreja Presbiteriana Redenção",
  version: "8.0.5",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF9b041e),
  secondary: const Color(0xFFcfb5b0),
  buttonBackground: const Color(0xFF9b041e),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFF9b041e),
  appBarTitle: const Color(0xFFffffff),
  appBarIcons: const Color(0xFFffffff),

  socialIconsBackground: const Color(0xFF9b041e),
  socialIconsForeground: const Color(0xFFffffff),
  topContentBorder: const Color(0xFFffffff),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.jpg"),

  loginButtonBackground: const Color(0xFF9b041e),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.jpg"),

  menuIcon: const Color(0xFFcfb5b0),
  menuActiveIcon: const Color(0xFF9b041e),
  menuUserBackground: const Color(0xFF9b041e),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFFcfb5b0),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFFcfb5b0),
  dividerText: const Color(0xFF7b5e58),
  iconBackground: const Color(0xFFcfb5b0),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);
