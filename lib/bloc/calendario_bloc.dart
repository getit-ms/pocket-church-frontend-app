import 'dart:async';

import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/item_evento/model.dart';
import 'package:rxdart/rxdart.dart';

enum ViewType { week, month }

class CalendarioBloc {
  BehaviorSubject<List<ItemEvento>> _calendario =
      new BehaviorSubject.seeded([]);
  BehaviorSubject<List<ItemEvento>> _eventosData =
      new BehaviorSubject.seeded([]);

  DateTime _dataInicio;
  DateTime _dataTermino;

  DateTime _dataSelecionada = DateTime.now().trunc();

  ViewType _viewType = ViewType.week;

  Stream<List<ItemEvento>> get calendario => _calendario.stream;

  DateTime get dataSelecionada => _dataSelecionada;

  ViewType get viewType => _viewType;

  Stream<List<ItemEvento>> get eventosData => _eventosData.stream;

  selecionaData(DateTime data) {
    _dataSelecionada = data;

    _eventosData.add(_calendario.value
        .where((evento) =>
            DateUtil.equalsDateOnly(evento.dataHoraReferencia, data))
        .toList());
  }

  trocaViewType(ViewType viewType) {
    _viewType = viewType;
  }

  trocaPeriodo({DateTime dataInicio, DateTime dataTermino}) {
    _dataInicio = dataInicio;
    _dataTermino = dataTermino;

    _carregaEventos();
  }

  _carregaEventos() async {
    if (_dataInicio != null && _dataTermino != null) {
      List<ItemEvento> eventos = await itemEventoApi.consultaPeriodo(
        dataInicio: _dataInicio,
        dataTermino: _dataTermino,
      );

      _calendario.add(eventos);

      selecionaData(_dataSelecionada);
    } else {
      _calendario.add([]);
    }
  }

  @override
  void dispose() {
    _calendario.close();
    _eventosData.close();
  }
}

CalendarioBloc calendarioBloc = CalendarioBloc();
