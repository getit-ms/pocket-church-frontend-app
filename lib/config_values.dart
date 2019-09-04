import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ibcb",
  nomeAplicativo: "Batista Central",
  nomeIgreja: "Igreja Batista Central de Brasília",
  version: "7.0.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF20364B),
  secondary: const Color(0xFFD41823),
  buttonBackground: const Color(0xFFD41823),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF000000),
  appBarIcons: const Color(0xFFD41823),

  socialIconsBackground: const Color(0xFFffffff),
  socialIconsForeground: const Color(0xFFD41823),
  topContentBorder: const Color(0xFFFEBD11),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.jpg"),

  loginButtonBackground: const Color(0xFFD41823),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.jpg"),

  menuIcon: const Color(0xFFD41823),
  menuActiveIcon: const Color(0xFF20364B),
  menuUserBackground: const Color(0xFFA20C14),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFFA20C14),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFF20364B),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFFD41823),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);