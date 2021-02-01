part of pocket_church.api;

class BoletimApi extends ApiBase {
  Future<Pagina<Boletim>> consulta(
      {String filtro, String tipo, int pagina, int tamanhoPagina}) async {
    return await get('/boletim/publicados',
        parameters: {
          'nome': filtro,
          'tipo': tipo,
          'pagina': pagina?.toString(),
          'total': tamanhoPagina?.toString()
        },
        typeMapper: paginaTypeMapper((json) => Boletim.fromJson(json)));
  }

  Future<Boletim> detalha(int id) async {
    return await get('/boletim/$id',
        typeMapper: (json) => Boletim.fromJson(json));
  }
}

final BoletimApi boletimApi = new BoletimApi();
