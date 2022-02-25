import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ipplanalto",
  nomeAplicativo: "IPP",
  nomeIgreja: "Igreja Presbiteriana do Planalto",
  version: "9.0.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF325789),
  secondary: const Color(0xFF325789),
  buttonBackground: const Color(0xFF325789),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF325789),
  appBarIcons: const Color(0xFF999999),

  socialIconsBackground: const Color(0xFF325789),
  socialIconsForeground: const Color(0xFF000000),
  topContentBorder: const Color(0xFF00ffffff),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.png"),

  loginButtonBackground: const Color(0xFF325789),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.jpg"),

  menuIcon: const Color(0xFF4f7ebd),
  menuActiveIcon: const Color(0xFF325789),
  menuUserBackground: const Color(0xFF325789),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFF325789),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFF4f7ebd),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFF325789),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);