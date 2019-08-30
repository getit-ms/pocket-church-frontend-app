part of pocket_church.api;

class CanticoApi extends ApiBase {
  Future<Pagina<Cantico>> consulta({
    String filtro,
    String tipo,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      '/cifra',
      parameters: {
        'filtro': filtro,
        'tipo': tipo,
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper((json) => Cantico.fromJson(json)),
    );
  }

  Future<Cantico> detalha(int id) async {
    return await get(
      '/cifra/$id',
      typeMapper: (json) => Cantico.fromJson(json),
    );
  }
}

CanticoApi canticoApi = new CanticoApi();
