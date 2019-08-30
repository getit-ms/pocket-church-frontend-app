
import 'dart:convert';

import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/model/institucional/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _INSTITUCIONAL = "institucional";

class InstitucionalBloc {
  BehaviorSubject<Institucional> _institucional = new BehaviorSubject<Institucional>();

  InstitucionalApi _institucionalApi = new InstitucionalApi();

  Stream<Institucional> get institucional => _institucional.stream;

  load() async {
    var sprefs = await SharedPreferences.getInstance();

    if (sprefs.containsKey(_INSTITUCIONAL)) {
      _institucional.add(Institucional.fromJson(json.decode(sprefs.getString(_INSTITUCIONAL))));
    }

    Institucional institucional = await _institucionalApi.consulta();

    sprefs.setString(_INSTITUCIONAL, json.encode(institucional.toJson()));

    _institucional.add(institucional);
  }

}

InstitucionalBloc institucionalBloc = new InstitucionalBloc();