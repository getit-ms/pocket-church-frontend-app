import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ipn",
  nomeAplicativo: "IP Vila Maria",
  nomeIgreja: "Igreja Presbiteriana de Vila Maria",
  version: "8.0.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF00C864),
  secondary: const Color(0xFFEBAF5A),
  buttonBackground: const Color(0xFF00C864),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF00C864),
  appBarIcons: const Color(0xFF00C864),

  socialIconsBackground: const Color(0xFFffffff),
  socialIconsForeground: const Color(0xFFEBAF5A),
  topContentBorder: const Color(0xFFffffffff),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.png"),

  loginButtonBackground: const Color(0xFF00C864),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.png"),

  menuIcon: const Color(0xFF00C864),
  menuActiveIcon: const Color(0xFFEBAF5A),
  menuUserBackground: const Color(0xFFEBAF5A),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFFEBAF5A),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.jpg"),

  dividerBackground: const Color(0xFF00C864),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFFEBAF5A),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);
