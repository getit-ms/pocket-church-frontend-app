part of pocket_church.api;

enum TipoEvento { EVENTO, EBD }

class EventoApi extends ApiBase {
  Future<Pagina<Evento>> consulta(
      {TipoEvento tipoEvento, int pagina, int tamanhoPagina}) async {
    return await get(
      '/evento/proximos',
      parameters: {
        'tipo': _mapTipoEvento(tipoEvento),
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString()
      },
      typeMapper: paginaTypeMapper(
        (json) => Evento.fromJson(json),
      ),
    );
  }

  Future<Evento> detalha(int id) async {
    return await get(
      '/evento/$id',
      typeMapper: (json) => Evento.fromJson(json),
    );
  }

  Future<ResultadoInscricao> realizaInscricao(int evento,
      {List<InscricaoEvento> inscricoes}) async {
    return await post(
      '/evento/$evento/inscricao',
      body: inscricoes.map((insc) => insc.toJson()).toList(),
      typeMapper: (json) => ResultadoInscricao.fromJson(json),
    );
  }

  Future<Pagina<InscricaoEvento>> consultaMinhasInscricoes(int evento,
      {int pagina, int tamanhoPagina}) async {
    return await get(
      '/evento/$evento/inscricoes/minhas',
      typeMapper: paginaTypeMapper(
        (json) => InscricaoEvento.fromJson(json),
      ),
    );
  }

  String _mapTipoEvento(TipoEvento tipoEvento) {
    if (tipoEvento == TipoEvento.EVENTO) {
      return 'EVENTO';
    } else if (tipoEvento == TipoEvento.EBD) {
      return 'EBD';
    }

    return null;
  }
}

final EventoApi eventoApi = new EventoApi();
