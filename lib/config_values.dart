import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ipcg",
  nomeAplicativo: "IPCG",
  nomeIgreja: "Igreja Presbiteriana Central do Gama",
  version: "10.0.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF4c9928),
  secondary: const Color(0xFF035431),
  buttonBackground: const Color(0xFF4c9928),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF4c9928),
  appBarIcons: const Color(0xFF4c9928),

  socialIconsBackground: const Color(0xFF035431),
  socialIconsForeground: const Color(0xFFffffff),
  topContentBorder: const Color(0xFF035431),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.jpg"),

  loginButtonBackground: const Color(0xFF4c9928),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.jpg"),

  menuIcon: const Color(0xFF4c9928),
  menuActiveIcon: const Color(0xFF035431),
  menuUserBackground: const Color(0xFF4c9928),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFF035431),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFF035431),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFF4c9928),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);