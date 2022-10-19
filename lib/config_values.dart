import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "ipbp",
  nomeAplicativo: "IPBP",
  nomeIgreja: "Igreja Presbiteriana Barra do Piraí",
  version: "9.0.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFF4C4566),
  secondary: const Color(0xFF345A35),
  buttonBackground: const Color(0xFF4C4566),
  buttonText: const Color(0xFFffffff),

  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF333333),
  appBarIcons: const Color(0xFF4C4566),

  socialIconsBackground: const Color(0xFFffffff),
  socialIconsForeground: const Color(0xFF4C4566),
  topContentBorder: const Color(0xFF4C4566),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.png"),

  loginButtonBackground: const Color(0xFFffffff),
  loginButtonText: const Color(0xFF4C4566),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.png"),

  menuIcon: const Color(0xFF4C4566),
  menuActiveIcon: const Color(0xFF4C4566),
  menuUserBackground: const Color(0xFF4C4566),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFF2A2344),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.png"),

  dividerBackground: const Color(0xFF4C4566),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFFffffff),
  iconForeground: const Color(0xFF4C4566),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground: const AssetImage("assets/imgs/institucional_background.png"),
);