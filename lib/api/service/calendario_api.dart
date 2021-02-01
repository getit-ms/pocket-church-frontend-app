part of pocket_church.api;

class CalendarioApi extends ApiBase {

  Future<Pagina<EventoCalendario>> consulta(int pagina, int tamanhoPagina) async {
    return await get<Pagina<EventoCalendario>>('/calendario',
        parameters: {
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString()
        },
        typeMapper: (paginaJson) {
          return Pagina<EventoCalendario>(
            resultados: listTypeMapper((json) => EventoCalendario.fromJson(json))(paginaJson['eventos']),
            pagina: paginaJson['proximaPagina'] != null ? int.parse(paginaJson['proximaPagina']) : null,
            hasProxima: paginaJson['possuiProximaPagina'],
          );
        }
    );
  }

}

final calendarioApi = new CalendarioApi();