import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/leitura_biblica/model.dart';
import 'package:rxdart/rxdart.dart';


class LeituraBloc {
  BehaviorSubject<PlanoLeitura> _plano = BehaviorSubject();
  BehaviorSubject<ProgressoLeitura> _leitura = BehaviorSubject(seedValue: ProgressoLeitura());
  BehaviorSubject<ProgressoSincronismo> _sincronizacao = BehaviorSubject(seedValue: ProgressoSincronismo());
  bool _possuiPlano = false;

  init() async {
    await _load();

    await checkLeitura();

    await sincroniza();
  }

  sincroniza() async {
    await leituraService.sincroniza(_updateSincronizacao);
  }

  _updateSincronizacao(ProgressoSincronismo progresso) async {
    _sincronizacao.add(progresso);

    await _load();

    await checkLeitura();
  }

  checkLeitura() async {
    _leitura.add(await leituraDAO.findPorcentagem());
  }

  _load() async {
    PlanoLeitura plano = await leituraDAO.findPlano();

    _possuiPlano = plano != null;
    _plano.add(plano);
  }

  get plano => _plano.stream;

  get possuiPlano => _possuiPlano;

  get sincronizacao => _sincronizacao.stream;

  get leitura => _leitura.stream;

  marcaLeitura(int dia, bool lido) async {
    await leituraDAO.atualizaLeitura(dia, lido);

    checkLeitura();

    leituraApi.marcaLeitura(dia, lido);
  }

}

LeituraBloc leituraBloc = LeituraBloc();
