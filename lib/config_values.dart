import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "pigv",
  nomeAplicativo: "PIGV",
  nomeIgreja: "Presbitério da Ilha do Governador",
  version: "8.3.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFFcc0000),
  secondary: const Color(0xFFffcc00),
  buttonBackground: const Color(0xFFcc0000),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF000000),
  appBarIcons: const Color(0xFFcc0000),

  socialIconsBackground: const Color(0xFFcc0000),
  socialIconsForeground: const Color(0xFFffffff),
  topContentBorder: const Color(0xFFcc0000),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.png"),

  loginButtonBackground: const Color(0xFFcc0000),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.png"),

  menuIcon: const Color(0xFFcc0000),
  menuActiveIcon: const Color(0xFF990000),
  menuUserBackground: const Color(0xFFcc0000),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFF990000),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFFcc0000),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFFcc0000),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);