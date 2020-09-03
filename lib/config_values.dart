import 'package:flutter/material.dart';

import './infra/infra.dart';

final Configuracao defaultConfig = const Configuracao(
  basePath: "https://getitmobilesolutions.com/app/rest",
  chaveIgreja: "demonstracao",
  nomeAplicativo: "Igreja das Américas",
  nomeIgreja: "Igreja Presbiteriana das Américas",
  version: "8.1.0",
);

final Tema defaultTema = const Tema(
  primary: const Color(0xFFB22D30),
  secondary: const Color(0xFFF7B848),
  buttonBackground: const Color(0xFF3A454E),
  buttonText: const Color(0xFFF7B848),
  appBarBackground: const Color(0xFFffffff),
  appBarTitle: const Color(0xFF3A454E),
  appBarIcons: const Color(0xFFB22D30),
  socialIconsBackground: const Color(0xFFffffff),
  socialIconsForeground: const Color(0xFFB22D30),
  topContentBorder: const Color(0xFFF7B848),
  homeLogo: const AssetImage("assets/imgs/home_logo.png"),
  homeBackground: const AssetImage("assets/imgs/home_background.png"),
  loginButtonBackground: const Color(0xFFF7B848),
  loginButtonText: const Color(0xFFB22D30),
  loginLogo: const AssetImage("assets/imgs/login_logo.png"),
  loginBackground: const AssetImage("assets/imgs/login_background.jpg"),
  menuIcon: const Color(0xFFB22D30),
  menuActiveIcon: const Color(0xFFF7B848),
  menuUserBackground: const Color(0xFFB22D30),
  menuUserText: const Color(0xFFffffff),
  badgeBackground: const Color(0xFFB22D30),
  badgeText: const Color(0xFFffffff),
  menuLogo: const AssetImage("assets/imgs/menu_logo.png"),
  menuBackground: const AssetImage("assets/imgs/menu_background.jpg"),
  dividerBackground: const Color(0xFFB22D30),
  dividerText: const Color(0xFFffffff),
  iconBackground: const Color(0xFFB22D30),
  iconForeground: const Color(0xFFffffff),
  institucionalLogo: const AssetImage("assets/imgs/institucional_logo.png"),
  institucionalBackground:
      const AssetImage("assets/imgs/institucional_background.png"),
);
