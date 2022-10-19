import 'dart:convert';
import 'dart:io';

import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/geral/model.dart';
import 'package:pocket_church/model/menu/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String MEMBRO = "membro";
const String MENU = "menu";

class AcessoBloc {
  BehaviorSubject<Membro> _membro =
  new BehaviorSubject<Membro>.seeded(null);
  BehaviorSubject<Menu> _menu =
  new BehaviorSubject<Menu>.seeded(Menu(submenus: []));
  BehaviorSubject<bool> _exigeAceiteTermo =
  new BehaviorSubject<bool>.seeded(false);

  Stream<Menu> get menu => _menu.stream;

  Stream<List<Menu>> get menuOptions =>
      _menu.stream.map((menu) {
        List<Menu> menus = [];

        menu?.submenus
            ?.where((child) => child.funcionalidade != 'INICIO_APLICATIVO')
            ?.forEach(
              (child) {
            if (child.link != null) {
              menus.add(Menu(
                icone: child.icone,
                link: child.link,
                funcionalidade: child.funcionalidade,
                nome: child.nome,
                notificacoes: child.notificacoes,
                ordem: child.ordem,
                categoria: child,
              ));
            }

            if (child.submenus != null) {
              child.submenus
                  .where((sbm) => child.funcionalidade != 'INICIO_APLICATIVO')
                  .forEach(
                    (sbm) {
                  if (sbm.link != null) {
                    menus.add(Menu(
                      icone: sbm.icone,
                      link: sbm.link,
                      funcionalidade: sbm.funcionalidade,
                      nome: sbm.nome,
                      notificacoes: sbm.notificacoes,
                      ordem: sbm.ordem,
                      categoria: child,
                    ));
                  }
                },
              );
            }
          },
        );

        return menus;
      });

  Menu get currentMenu => _menu.value;

  Stream<bool> get exigeAceiteTermo => _exigeAceiteTermo.stream;

  Stream<Membro> get membro => _membro.stream;

  Membro get currentMembro => _membro.value;

  AcessoBloc();

  init() async {
    Configuracao config = configuracaoBloc.currentConfig;

    var sprefs = await SharedPreferences.getInstance();

    if (sprefs.containsKey(MENU)) {
      _initMenu(sprefs);
    }

    if (config.authorization != null) {
      _initMembro(sprefs);

      refresh(config);
    } else {
      refreshMenu(config);
    }
  }

  void _initMenu(SharedPreferences sprefs) {
    try {
      _menu.add(Menu.fromJson(json.decode(sprefs.getString(MENU))));
    } catch (ex) {
      sprefs.remove(MENU);
    }
  }

  void _initMembro(SharedPreferences sprefs) {
    if (sprefs.containsKey(MEMBRO)) {
      try {
        _membro.add(Membro.fromJson(json.decode(sprefs.getString(MEMBRO))));
      } catch (ex) {
        sprefs.remove(MEMBRO);
      }
    }
  }

  Stream<bool> temAcesso(Funcionalidade func) {
    return _menu.stream.map((menu) => _temAcesso(func, menu: menu));
  }

  bool _temAcesso(Funcionalidade func, {Menu menu}) {
    menu = menu ?? _menu.value;

    if (menu != null) {
      if ("Funcionalidade.${menu.funcionalidade}" == func.toString()) {
        return true;
      }

      if (menu.submenus?.isNotEmpty ?? false) {
        for (Menu child in menu.submenus) {
          if (_temAcesso(func, menu: child)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  Future<Membro> login(String username,
      String password,) async {
    var sprefs = await SharedPreferences.getInstance();

    Configuracao config = configuracaoBloc.currentConfig;

    Acesso acesso = await acessoApi.login(
      username: username,
      password: password,
      tipoDispositivo:
      Platform.isIOS ? TipoDispositivo.IOS : TipoDispositivo.ANDROID,
      versao: config.version,
    );

    _exigeAceiteTermo.add(acesso.exigeAceiteTermo);
    _membro.add(acesso.membro);
    _menu.add(acesso.menu);

    sprefs.setString(MEMBRO, json.encode(acesso.membro.toJson()));
    sprefs.setString(MENU, json.encode(acesso.menu.toJson()));
    configuracaoBloc.update(
      config.copyWith(authorization: acesso.auth),
    );

    return acesso.membro;
  }

  bool get autenticado {
    return _membro.value != null;
  }

  logout() async {
    var sprefs = await SharedPreferences.getInstance();

    Configuracao config = configuracaoBloc.currentConfig;

    acessoApi.logout();

    _exigeAceiteTermo.add(false);
    _membro.add(null);
    sprefs.remove(MEMBRO);

    await configuracaoBloc.update(new Configuracao(
      version: config.version,
      chaveIgreja: config.chaveIgreja,
      basePath: config.basePath,
      nomeAplicativo: config.nomeAplicativo,
      nomeIgreja: config.nomeIgreja,
      chaveDispositivo: config.chaveDispositivo,
      template: config.template,
    ));

    refreshMenu();
  }

  Future refresh([Configuracao config]) async {
    if (config == null) {
      config = configuracaoBloc.currentConfig;
    }

    var sprefs = await SharedPreferences.getInstance();

    Acesso acesso = await acessoApi.refresh(
      version: config.version,
    );

    _exigeAceiteTermo.add(acesso.exigeAceiteTermo);
    _membro.add(acesso.membro);
    _menu.add(acesso.menu);

    sprefs.setString(MENU, json.encode(acesso.menu.toJson()));
    sprefs.setString(MEMBRO, json.encode(acesso.membro.toJson()));

    configuracaoBloc.update(
      config.copyWith(authorization: acesso.auth),
    );
  }

  refreshMenu([Configuracao config]) async {
    if (config == null) {
      config = configuracaoBloc.currentConfig;
    }

    var sprefs = await SharedPreferences.getInstance();

    Menu menu = await acessoApi.buscaMenu(config.version);

    _menu.add(menu);

    sprefs.setString(MENU, json.encode(menu.toJson()));
  }
}

AcessoBloc acessoBloc = new AcessoBloc();
