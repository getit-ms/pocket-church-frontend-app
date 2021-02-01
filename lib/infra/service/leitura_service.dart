part of pocket_church.infra;

final String _CHAVE_CACHE_SINCRONISMO_LEITURA = "filtro_incompleto_leitura";

class LeituraService {
  sincroniza(ProgressoObserver observer) async {
    PlanoLeitura plano = await leituraApi.buscaPlanoLeituraSelecionado();

    await leituraDAO.mergePlano(plano);

    var sprefs = await SharedPreferences.getInstance();

    FiltroSincronismoLeitura filtro = await _preparaFiltro(sprefs);

    try {
      observer(ProgressoSincronismo(
        sincronizando: true,
      ));

      await _sincOnline2Offline(sprefs, filtro, observer);

      await _sincOffline2Online();
    } finally {
      observer(ProgressoSincronismo(
        sincronizando: false,
      ));
    }
  }

  _sincOffline2Online() async {
    List<Leitura> leituras = await leituraDAO.findNaoSincronizados();

    for (Leitura leitura in leituras) {
      await leituraApi.marcaLeitura(leitura.dia.id, leitura.lido);
    }
  }

  _sincOnline2Offline(SharedPreferences sprefs, FiltroSincronismoLeitura filtro,
      ProgressoObserver observer,
      [double progresso = 0]) async {
    sprefs.setString(_CHAVE_CACHE_SINCRONISMO_LEITURA, json.encode(filtro.toJson()));
    observer(ProgressoSincronismo(sincronizando: true, porcentagem: progresso));

    Pagina<Leitura> pagina = await leituraApi.buscaLeituraSelecionada(
      ultimaAtualizacao: filtro.ultimaAtualizacao,
      pagina: filtro.pagina,
      tamanhoPagina: filtro.total,
    );

    if (pagina.resultados?.isNotEmpty ?? false) {
      pagina.resultados.forEach(leituraDAO.mergeLeitura);
    }

    if (pagina.hasProxima) {
      await _sincOnline2Offline(
          sprefs,
          FiltroSincronismoLeitura(
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
    if (sprefs.containsKey(_CHAVE_CACHE_SINCRONISMO_LEITURA)) {
      return FiltroSincronismoLeitura.fromJson(
          json.decode(sprefs.getString(_CHAVE_CACHE_SINCRONISMO_LEITURA)));
    } else {
      var ultimaAlteracao = await leituraDAO.findUltimaAlteracao();
      return FiltroSincronismoLeitura(ultimaAtualizacao: ultimaAlteracao);
    }
  }
}

class FiltroSincronismoLeitura {
  final int pagina;
  final int total;
  final DateTime ultimaAtualizacao;

  FiltroSincronismoLeitura({
    this.pagina = 1,
    this.total = 10,
    this.ultimaAtualizacao,
  });

  FiltroSincronismoLeitura.fromJson(Map<String, dynamic> json)
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

LeituraService leituraService = new LeituraService();
