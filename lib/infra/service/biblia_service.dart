part of pocket_church.infra;

final String _CHAVE_CACHE_SINCRONISMO_BIBLIA = "filtro_incompleto_biblia";

class BibliaService {
  sincroniza(ProgressoObserver observer) async {
    var sprefs = await SharedPreferences.getInstance();

    FiltroSincronismoBiblia filtro = await _preparaFiltro(sprefs);

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

  _sinc(SharedPreferences sprefs, FiltroSincronismoBiblia filtro,
      ProgressoObserver observer) async {
    double progresso = 0;
    Pagina<LivroBiblia> pagina;

    do {
      sprefs.setString(
          _CHAVE_CACHE_SINCRONISMO_BIBLIA, json.encode(filtro.toJson()));
      observer(
          ProgressoSincronismo(sincronizando: true, porcentagem: progresso));

      pagina = await bibliaApi.consulta(
        ultimaAtualizacao: filtro.ultimaAtualizacao,
        pagina: filtro.pagina,
        tamanhoPagina: filtro.total,
      );

      if (pagina.resultados?.isNotEmpty ?? false) {
        pagina.resultados.forEach(bibliaDAO.mergeLivroBiblia);
      }

      progresso =
          100 * pagina.pagina.toDouble() / pagina.totalPaginas.toDouble();
      filtro = FiltroSincronismoBiblia(
        pagina: filtro.pagina + 1,
        ultimaAtualizacao: filtro.ultimaAtualizacao,
      );
    } while (pagina.hasProxima);

    sprefs.remove(_CHAVE_CACHE_SINCRONISMO_BIBLIA);
  }

  _preparaFiltro(SharedPreferences sprefs) async {
    if (sprefs.containsKey(_CHAVE_CACHE_SINCRONISMO_BIBLIA)) {
      return FiltroSincronismoBiblia.fromJson(
          json.decode(sprefs.getString(_CHAVE_CACHE_SINCRONISMO_BIBLIA)));
    } else {
      var ultimaAlteracao = await bibliaDAO.findUltimaAlteracaoLivroBiblia();
      return FiltroSincronismoBiblia(ultimaAtualizacao: ultimaAlteracao);
    }
  }
}

class FiltroSincronismoBiblia {
  final int pagina;
  final int total;
  final DateTime ultimaAtualizacao;

  FiltroSincronismoBiblia({
    this.pagina = 1,
    this.total = 3,
    this.ultimaAtualizacao,
  });

  FiltroSincronismoBiblia.fromJson(Map<String, dynamic> json)
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

BibliaService bibliaService = new BibliaService();
