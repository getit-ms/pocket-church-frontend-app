import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "iceso",
  nomeAplicativo: "ICESO",
  nomeIgreja: "Igreja Cristã Evangélica do Setor Oeste",
  version: "7.0.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF2F4593),
  secondary: const Color(0xFF333333),
  buttonBackground: const Color(0xFF2F4593),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF333333),
  appBarIcons: const Color(0xFF2F4593),

  socialIconsBackground: const Color(0xFFffffff),
  socialIconsForeground: const Color(0xFF2F4593),
  topContentBorder: const Color(0xFF2F4593),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.png"),

  loginButtonBackground: const Color(0xFF2F4593),
  loginButtonText: const Color(0xFFffffff),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.png"),

  menuIcon: const Color(0xFF2F4593),
  menuActiveIcon: const Color(0xFF2F4593),
  menuUserBackground: const Color(0xFF2F4593),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFF333333),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFF2F4593),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFFffffff),
  iconForeground: const Color(0xFF2F4593),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);