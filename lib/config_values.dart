import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ipn",
  nomeAplicativo: "IPN",
  nomeIgreja: "Igreja Presbiteriana Nacional",
  version: "7.0.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF006fb7),
  secondary: const Color(0xFF262262),
  buttonBackground: const Color(0xFF006fb7),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFF006fb7),
  appBarTitle: const Color(0xFFffffff),
  appBarIcons: const Color(0xFFffffff),

  socialIconsBackground: const Color(0xFF006fb7),
  socialIconsForeground: const Color(0xFF262262),
  topContentBorder: const Color(0xFF262262),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.jpg"),

  loginButtonBackground: const Color(0xFF006fb7),
  loginButtonText: const Color(0xFFFFFFFF),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.jpg"),

  menuIcon: const Color(0xFF006fb7),
  menuActiveIcon: const Color(0xFF262262),
  menuUserBackground: const Color(0xFF262262),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFF262262),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/home_background.jpg"),

  dividerBackground: const Color(0xFFdff2ff),
  dividerText: const Color(0xFF006fb7),
  iconBackground: const Color(0xFF006fb7),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);