import 'dart:async';

import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/geral/model.dart';
import 'package:pocket_church/model/item_evento/model.dart';
import 'package:pocket_church/model/menu/model.dart';
import 'package:rxdart/rxdart.dart';

enum StatusFiltro { vazio, buscando, nao_econtrado, concluido }

class FiltroBloc {
  BehaviorSubject<StatusFiltro> _status =
      new BehaviorSubject.seeded(StatusFiltro.vazio);
  BehaviorSubject<List<Menu>> _menus = new BehaviorSubject.seeded([]);
  BehaviorSubject<List<ItemEvento>> _itensEvento =
      new BehaviorSubject.seeded([]);
  BehaviorSubject<List<Membro>> _membros = new BehaviorSubject.seeded([]);

  Stream<StatusFiltro> get status => _status.stream;

  Stream<List<Menu>> get menus => _menus.stream;

  Stream<List<ItemEvento>> get itensEvento => _itensEvento.stream;

  Stream<List<Membro>> get membros => _membros.stream;

  Timer _currentFiltro;

  filtra(String filtro) async {
    _menus.add([]);
    _itensEvento.add([]);
    _membros.add([]);

    _currentFiltro?.cancel();
    if (filtro.isNotEmpty) {
      _status.add(StatusFiltro.buscando);

      _currentFiltro = Timer(const Duration(milliseconds: 500), () async {
        try {
          await Future.wait([
            _filtraMenus(filtro),
            _filtraMembroes(filtro),
            _filtraItensEvento(filtro),
          ]);
        } finally {
          if (_membros.value.isEmpty &&
              _menus.value.isEmpty &&
              _itensEvento.value.isEmpty) {
            _status.add(StatusFiltro.nao_econtrado);
          } else {
            _status.add(StatusFiltro.concluido);
          }
        }
      });
    } else {
      _status.add(StatusFiltro.vazio);
    }
  }

  dispose() {
    _status.close();
    _menus.close();
    _itensEvento.close();
    _membros.close();
  }

  Future<void> _filtraMenus(String filtro) async {
    List<Menu> menus = [];

    var filter = filtro.toLowerCase();
    acessoBloc.currentMenu.submenus.forEach((child) {
      if (child.link != null &&
          child.funcionalidade != 'INICIO_APLICATIVO' &&
          child.nome.toLowerCase().contains(filter)) {
        menus.add(child);
      }

      if (child.submenus != null) {
        child.submenus.where((sbm) {
          return child.funcionalidade != 'INICIO_APLICATIVO' &&
              sbm.nome.toLowerCase().contains(filter);
        }).forEach((sbm) {
          if (sbm.link != null) {
            menus.add(sbm);
          }
        });
      }
    });

    _menus.add(menus);
  }

  Future<void> _filtraMembroes(String filtro) async {
    if (acessoBloc.temAcesso(Funcionalidade.CONSULTAR_CONTATOS_IGREJA)) {
      try {
        Pagina<Membro> membros =
            await membroApi.consulta(filtro: filtro, tamanhoPagina: 15);

        _membros.add(membros.resultados ?? []);
      } catch (ex, stack) {
        print(ex);
        print(stack);
      }
    }
  }

  Future<void> _filtraItensEvento(String filtro) async {
    try {
      Pagina<ItemEvento> itens = await itemEventoApi.consultaTimeline(
          filtro: filtro, tamanhoPagina: 15);

      _itensEvento.add(itens.resultados ?? []);
    } catch (ex, stack) {
      print(ex);
      print(stack);
    }
  }
}
