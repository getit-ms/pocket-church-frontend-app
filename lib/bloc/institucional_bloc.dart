import 'dart:convert';

import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/banner/model.dart';
import 'package:pocket_church/model/enquete/model.dart';
import 'package:pocket_church/model/geral/model.dart';
import 'package:pocket_church/model/institucional/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _INSTITUCIONAL = "institucional";
const String _BANNERS = "banners";

class InstitucionalBloc {
  BehaviorSubject<Institucional> _institucional =
      new BehaviorSubject<Institucional>();
  BehaviorSubject<List<Banner>> _banners =
      BehaviorSubject<List<Banner>>.seeded([]);
  BehaviorSubject<List<Enquete>> _enquetes =
      BehaviorSubject<List<Enquete>>.seeded([]);
  BehaviorSubject<List<Membro>> _aniversariantes =
      BehaviorSubject<List<Membro>>.seeded([]);

  InstitucionalApi _institucionalApi = new InstitucionalApi();
  BannerApi _bannerApi = new BannerApi();
  EnqueteApi _enqueteApi = new EnqueteApi();
  MembroApi _membroApi = new MembroApi();

  Stream<Institucional> get institucional => _institucional.stream;

  Stream<List<Banner>> get banners => _banners.stream;

  List<Banner> get currentBanners => _banners.value;

  Stream<List<Enquete>> get enquetes => _enquetes.stream;

  List<Enquete> get currentEnquetes => _enquetes.value;

  Stream<List<Membro>> get aniversariantes => _aniversariantes.stream;

  List<Membro> get currentAniversariantes => _aniversariantes.value;

  load() async {
    var sprefs = await SharedPreferences.getInstance();

    await _loadInstitucional(sprefs);
    await _loadBanners(sprefs);
    await loadEnquetes();
    await _loadAniversariantes();
  }

  _loadInstitucional(SharedPreferences sprefs) async {
    if (sprefs.containsKey(_INSTITUCIONAL)) {
      _institucional.add(Institucional.fromJson(
          json.decode(sprefs.getString(_INSTITUCIONAL))));
    }

    try {
      Institucional institucional = await _institucionalApi.consulta();

      sprefs.setString(_INSTITUCIONAL, json.encode(institucional.toJson()));

      _institucional.add(institucional);
    } catch (ex, stack) {
      print(ex);
      print(stack);
    }
  }

  _loadBanners(SharedPreferences sprefs) async {
    if (sprefs.containsKey(_BANNERS)) {
      dynamic jsonList = json.decode(sprefs.getString(_BANNERS));
      List<Banner> banners = (jsonList as List)
          .map((json) => (json as Map).map((k, v) => MapEntry(k as String, v)))
          .map((json) => Banner.fromJson(json))
          .toList();
      _banners.add(banners);
    }

    try {
      List<Banner> banners = await _bannerApi.consulta();

      sprefs.setString(_BANNERS,
          json.encode(banners.map((banner) => banner.toJson()).toList()));

      _banners.add(banners);
    } catch (ex, stack) {
      print(ex);
      print(stack);
    }
  }

  loadEnquetes() async {
    acessoBloc.membro.listen((membro) async {
      if (acessoBloc.temAcesso(Funcionalidade.REALIZAR_VOTACAO)) {
        try {
          Pagina<Enquete> enquetes = await _enqueteApi.consulta();

          _enquetes.add(enquetes.resultados ?? []);
        } catch (ex, stack) {
          print(ex);
          print(stack);
        }
      } else {
        _enquetes.add([]);
      }
    });
  }

  _loadAniversariantes() async {
    acessoBloc.membro.listen((membro) async {
      if (acessoBloc.temAcesso(Funcionalidade.ANIVERSARIANTES)) {
        try {
          List<Membro> enquetes = await _membroApi.buscaAniversariantes();

          DateTime hoje = DateTime.now();
          int aniversarioHoje = hoje.month * 100 + hoje.day;

          _aniversariantes.add(enquetes
                  ?.where((membro) => membro.diaAniversario == aniversarioHoje)
                  ?.toList() ??
              []);
        } catch (ex, stack) {
          print(ex);
          print(stack);
        }
      } else {
        _aniversariantes.add([]);
      }
    });
  }
}

InstitucionalBloc institucionalBloc = new InstitucionalBloc();
