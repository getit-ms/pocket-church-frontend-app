part of pocket_church.infra;


final String _CHAVE_CACHE_SINCRONISMO_HINO = "filtro_incompleto_hino";

class HinoService {
  sincroniza(ProgressoObserver observer) async {
    var sprefs = await SharedPreferences.getInstance();

    FiltroSincronismoHino filtro = await _preparaFiltro(sprefs);

    try {
      observer(ProgressoSincronismo(
        sincronizando: true,
      ));

      await _sinc(sprefs, filtro, observer);
    } finally {
      observer(ProgressoSincronismo(
        sincronizando: false,
      ));
    }
  }

  _sinc(SharedPreferences sprefs, FiltroSincronismoHino filtro,
      ProgressoObserver observer,
      [double progresso = 0]) async {
    sprefs.setString(_CHAVE_CACHE_SINCRONISMO_HINO, json.encode(filtro.toJson()));
    observer(ProgressoSincronismo(sincronizando: true, porcentagem: progresso));

    Pagina<Hino> pagina = await hinoApi.consulta(
      ultimaAtualizaca: filtro.ultimaAtualizacao,
      pagina: filtro.pagina,
      tamanhoPagina: filtro.total,
    );

    if (pagina.resultados?.isNotEmpty ?? false) {
      pagina.resultados.forEach(hinoDAO.mergeHino);
    }

    if (pagina.hasProxima) {
      await _sinc(
          sprefs,
          FiltroSincronismoHino(
            pagina: filtro.pagina + 1,
            ultimaAtualizacao: filtro.ultimaAtualizacao,
          ),
          observer,
          100 * pagina.pagina.toDouble() / pagina.totalPaginas.toDouble());
    } else {
      sprefs.remove(_CHAVE_CACHE_SINCRONISMO_LEITURA);
    }
  }

  _preparaFiltro(SharedPreferences sprefs) async {
    if (sprefs.containsKey(_CHAVE_CACHE_SINCRONISMO_HINO)) {
      return FiltroSincronismoHino.fromJson(
          json.decode(sprefs.getString(_CHAVE_CACHE_SINCRONISMO_HINO)));
    } else {
      var ultimaAlteracao = await hinoDAO.findUltimaAlteracaoHinos();
      return FiltroSincronismoHino(ultimaAtualizacao: ultimaAlteracao);
    }
  }
}


class FiltroSincronismoHino {
  final int pagina;
  final int total;
  final DateTime ultimaAtualizacao;

  FiltroSincronismoHino({
    this.pagina = 1,
    this.total = 10,
    this.ultimaAtualizacao,
  });

  FiltroSincronismoHino.fromJson(Map<String, dynamic> json)
      : pagina = json['pagina'],
        total = json['total'],
        ultimaAtualizacao = json['ultimaAtualizacao'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['ultimaAtualizacao'])
            : null;

  Map<String, dynamic> toJson() => {
    'pagina': pagina,
    'total': total,
    'ultimaAtualizacao': ultimaAtualizacao?.millisecondsSinceEpoch,
  };
}


HinoService hinoService = new HinoService();