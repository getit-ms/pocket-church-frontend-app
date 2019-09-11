import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/bloc/institucional_bloc.dart';
import 'package:pocket_church/funcionalidade/layouts/reativo/reativo.dart';
import 'package:pocket_church/funcionalidade/layouts/tradicional/tradicional.dart';
import 'package:pocket_church/page_apresentacao.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './infra/infra.dart';
import 'bloc/biblia_bloc.dart';
import 'bloc/hino_bloc.dart';
import 'bloc/leitura_bloc.dart';
import 'funcionalidade/notificacao/notificacao.dart';

void main() async {
  runApp(
    PrepareApp(
      execute: _loadingExecute,
      child: ConfiguracaoApp(
        child: PocketChurchApp(),
      ),
    ),
  );
}

Future<void> _loadingExecute(BuildContext context) async {
  Intl.defaultLocale = 'pt_BR';
  await initializeDateFormatting();

  var min = Future.delayed(const Duration(milliseconds: 2000), () {});

  await arquivoService.init();
  await pcDatabase.init();

  pdfService.configure(width: 1500);

  await configuracaoBloc.init();

  await acessoBloc.init();

  institucionalBloc.load();

  messagingService.register();

  // On Resume padrão
  messagingListener.addWhenResume(
    (notificacao) => NavigatorUtil.navigate(context,
        builder: (context) => PageListaNotificacoes()),
  );

  await min;

  acessoBloc.menu.listen((meun) async {
    if (acessoBloc.temAcesso(Funcionalidade.BIBLIA)) {
      try {
        await bibliaBloc.init();
      } catch (ex) {
        print(ex);
      }
    }

    if (acessoBloc.temAcesso(Funcionalidade.CONSULTAR_PLANOS_LEITURA_BIBLICA)) {
      try {
        await leituraBloc.init();
      } catch (ex) {
        print(ex);
      }
    }

    if (acessoBloc.temAcesso(Funcionalidade.CONSULTAR_HINARIO)) {
      try {
        await hinoBloc.init();
      } catch (ex) {
        print(ex);
      }
    }
  });
}

class PrepareApp extends StatefulWidget {
  final Widget child;
  final Future<void> Function(BuildContext) execute;

  const PrepareApp({this.child, this.execute});

  @override
  _PrepareAppState createState() => _PrepareAppState();
}

class _PrepareAppState extends State<PrepareApp> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  _prepare() async {
    setState(() {
      _loading = true;
    });

    try {
      await widget.execute(context);
    } catch (ex) {
      print("Falha no splash : $ex");
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/splash/splash.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _loading ? 0 : 1,
        duration: const Duration(milliseconds: 500),
        child: widget.child,
      ),
    );
  }
}

class PocketChurchApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _PocketChurchAppState createState() => _PocketChurchAppState();
}

class _PocketChurchAppState extends State<PocketChurchApp> {

  @override
  Widget build(BuildContext context) {
    var configuracaoApp = ConfiguracaoApp.of(context);

    Configuracao config = configuracaoApp.config;

    Widget home = PageApresentacao();

    if (config.template == 'reativo') {
      home = LayoutReativo();
    } else if (config.template == 'tradicional') {
      home = LayoutTradicional();
    }

    return MaterialApp(
      locale: const Locale('pt-BR'),
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      home: home,
    );
  }
}
