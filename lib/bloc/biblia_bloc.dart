import 'package:pocket_church/infra/infra.dart';
import 'package:rxdart/rxdart.dart';

class BibliaBloc {
  BehaviorSubject<ProgressoSincronismo> _sincronizacao =
      BehaviorSubject(seedValue: ProgressoSincronismo());

  init() async {
    await sincroniza();
  }

  sincroniza() async {
    await bibliaService.sincroniza(_updateSincronizacao);
  }

  _updateSincronizacao(ProgressoSincronismo progresso) async {
    _sincronizacao.add(progresso);
  }

  get sincronizacao => _sincronizacao.stream;
}

BibliaBloc bibliaBloc = BibliaBloc();
