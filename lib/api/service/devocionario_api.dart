part of pocket_church.api;


class DevocionarioApi extends ApiBase {
  Future<Pagina<DiaDevocionario>> consulta(
      {DateTime dataInicio, DateTime dataTermino, int pagina, int tamanhoPagina}) async {
    return await get('/devocionario/publicados',
        parameters: {
          'dataInicio': StringUtil.formatIso(dataInicio),
          'dataTermino': StringUtil.formatIso(dataTermino),
          'pagina': pagina?.toString(),
          'total': tamanhoPagina?.toString()
        },
        typeMapper: paginaTypeMapper((json) => DiaDevocionario.fromJson(json)));
  }

}

final DevocionarioApi devocionarioApi = new DevocionarioApi();
