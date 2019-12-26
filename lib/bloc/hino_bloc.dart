import 'package:pocket_church/infra/infra.dart';
import 'package:rxdart/rxdart.dart';

class HinoBloc {
  BehaviorSubject<ProgressoSincronismo> _sincronizacao =
      BehaviorSubject.seeded(ProgressoSincronismo());

  init() async {
    await sincroniza();
  }

  sincroniza() async {
    await hinoService.sincroniza(_updateSincronizacao);
  }

  _updateSincronizacao(ProgressoSincronismo progresso) async {
    _sincronizacao.add(progresso);
  }

  get sincronizacao => _sincronizacao.stream;
}

HinoBloc hinoBloc = HinoBloc();
