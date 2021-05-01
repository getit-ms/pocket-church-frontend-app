import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ipmadalena",
  nomeAplicativo: "IP Madalena",
  nomeIgreja: "Igreja Presbiteriana Madalena",
  version: "8.3.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF003902),
  secondary: const Color(0xFF003902),
  buttonBackground: const Color(0xFF003902),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF333333),
  appBarIcons: const Color(0xFF003902),

  socialIconsBackground: const Color(0xFFffffff),
  socialIconsForeground: const Color(0xFF003902),
  topContentBorder: const Color(0xFF003902),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.jpg"),

  loginButtonBackground: const Color(0xFF003902),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.jpg"),

  menuIcon: const Color(0xFF003902),
  menuActiveIcon: const Color(0xFF003902),
  menuUserBackground: const Color(0xFF003902),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFFff0000),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFF003902),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFF003902),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);