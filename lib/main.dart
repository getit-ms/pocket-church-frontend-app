import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/bloc/institucional_bloc.dart';
import 'package:pocket_church/funcionalidade/layouts/reativo/reativo.dart';
import 'package:pocket_church/funcionalidade/layouts/tradicional/tradicional.dart';
import 'package:pocket_church/page_apresentacao.dart';

import './infra/infra.dart';
import 'api/api.dart';
import 'bloc/biblia_bloc.dart';
import 'bloc/hino_bloc.dart';
import 'bloc/leitura_bloc.dart';
import 'componentes/componentes.dart';
import 'config_values.dart';
import 'funcionalidade/notificacao/notificacao.dart';
import 'model/sugestao/model.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white54,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

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
  bool _error = false;

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  _prepare() async {
    SystemChrome.setEnabledSystemUIOverlays([]);

    setState(() {
      _loading = true;
    });

    try {
      await widget.execute(context);
    } catch (ex) {
      print("Falha no splash : $ex");

      _notificaErroInicializacao(ex);

      setState(() {
        _error = true;
      });
    }

    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);

    setState(() {
      _loading = false;
    });
  }

  void _notificaErroInicializacao(ex) {
    try {
      ChamadoApi chamadoApi = new ChamadoApi();

      if (apiConfig.defaultHeaders['Dispositivo'] == null) {
        apiConfig.defaultHeaders['Dispositivo'] = 'undefined';
      }

      if (apiConfig.defaultHeaders['Igreja'] == null) {
        apiConfig.defaultHeaders['Igreja'] = defaultConfig.chaveIgreja;
      }

      chamadoApi.cadastra(new Sugestao(
        tipo: 'ERRO',
        descricao: "Falha ao iniciar app: \n$ex",
        nomeSolicitante: 'Chamado Automático',
        emailSolicitante: 'suporte@getitmobilesolutions.com',
      ));
    } catch (ex) {
      print("Falha ao notificar erro: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Material(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: const <Widget>[
              Icon(
                FontAwesomeIcons.sadCry,
                size: 30,
                color: Colors.black54,
              ),
              SizedBox(
                width: 10,
              ),
              IntlText(
                "mensagens.MSG-608",
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
