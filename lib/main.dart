import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/bloc/institucional_bloc.dart';
import 'package:pocket_church/funcionalidade/layouts/reativo/reativo.dart';
import 'package:pocket_church/funcionalidade/layouts/tradicional/tradicional.dart';
import 'package:pocket_church/page_apresentacao.dart';
import 'package:pocket_church/timeline/timeline.dart';

import './infra/infra.dart';
import 'bloc/biblia_bloc.dart';
import 'bloc/hino_bloc.dart';
import 'bloc/leitura_bloc.dart';
import 'funcionalidade/notificacao/notificacao.dart';

void main() async {

  runApp(PrepareApp(
    execute: (BuildContext context) async {
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

        if (acessoBloc
            .temAcesso(Funcionalidade.CONSULTAR_PLANOS_LEITURA_BIBLICA)) {
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
    },
    child: ConfiguracaoApp(
      child: PocketChurchApp(),
    ),
  ));
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
    return MaterialApp(
      home: AnimatedCrossFade(
        firstChild: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/splash/splash.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        secondChild: widget.child,
        crossFadeState:
            _loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var configuracaoApp = ConfiguracaoApp.of(context);

    Configuracao config = configuracaoApp.config;
    Tema tema = configuracaoApp.tema;

    Widget home = PageApresentacao();

    if (config.template == 'reativo') {
      home = LayoutReativo();
    } else if (config.template == 'tradicional') {
      home = LayoutTradicional();
    }

    return MaterialApp(
      title: config.nomeAplicativo ?? "",
      theme: ThemeData(
        accentColor: tema.primary,
        primaryColor: tema.primary,
        buttonColor: tema.buttonBackground,
        appBarTheme: AppBarTheme.of(context).copyWith(
            color: tema.appBarBackground,
            textTheme: Theme.of(context).primaryTextTheme.apply(
                  bodyColor: tema.appBarTitle,
                ),
            iconTheme: Theme.of(context)
                .primaryIconTheme
                .copyWith(color: tema.appBarIcons)),
        dividerColor: tema.dividerBackground,
        iconTheme: Theme.of(context)
            .primaryIconTheme
            .copyWith(color: tema.iconForeground),
      ),
      home: home,
    );
  }
}
