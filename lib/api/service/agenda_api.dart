part of pocket_church.api;

class AgendaApi extends ApiBase {
  Future<List<CalendarioAconselhamento>> buscaCalendarios() async {
    return await get(
      '/agenda',
      typeMapper: listTypeMapper(
        (json) => CalendarioAconselhamento.fromJson(json),
      ),
    );
  }

  Future<Aconselhamento> agendar({
    int calendario,
    int horario,
    DateTime data,
  }) async {
    return await post(
      '/agenda/$calendario/agendar',
      body: {
        'horario': horario.toString(),
        'data': StringUtil.formatData(data, pattern: "yyyy-MM-dd")
      },
      typeMapper: (json) => Aconselhamento.fromJson(json),
    );
  }

  Future<Aconselhamento> confirma({
    int calendario,
    int agendamento,
  }) async {
    return await post(
      '/agenda/$calendario/confirmar/$agendamento',
      typeMapper: (json) => Aconselhamento.fromJson(json),
    );
  }

  Future<Aconselhamento> cancelar({
    int calendario,
    int agendamento,
  }) async {
    return await post(
      '/agenda/$calendario/confirmar/$agendamento',
      typeMapper: (json) => Aconselhamento.fromJson(json),
    );
  }

  Future<Pagina<Aconselhamento>> consultarMeusAgendamentos(
      {int pagina, int tamanhoPagina}) async {
    return await get(
      '/agenda/agendamentos/meus',
      parameters: {
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper(
        (json) => Aconselhamento.fromJson(json),
      ),
    );
  }

  Future<List<EventoCalendarioAconselhamento>> buscaHorarios(int calendario,
      {DateTime inicio, DateTime termino}) async {
    return await get(
      '/agenda/$calendario/agenda',
      parameters: {
        'di': StringUtil.formatIso(inicio),
        'df': StringUtil.formatIso(termino),
      },
      typeMapper: listTypeMapper(
        (json) => EventoCalendarioAconselhamento.fromJson(json),
      ),
    );
  }
}

final AgendaApi agendaApi = new AgendaApi();
