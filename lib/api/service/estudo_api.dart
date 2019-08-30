part of pocket_church.api;

class EstudoApi extends ApiBase {

  Future<List<CategoriaEstudo>> consultaCategorias() async {
    return await get('/estudo/categoria',
        typeMapper: listTypeMapper((json) => CategoriaEstudo.fromJson(json)));
  }

  Future<Pagina<Estudo>> consulta({int categoria, int pagina, int tamanhoPagina}) async {
    return await get('/estudo/publicados',
        parameters: {
          'categoria': categoria?.toString(),
          'pagina': pagina?.toString(),
          'total': tamanhoPagina?.toString()
        }, typeMapper: paginaTypeMapper((json) => Estudo.fromJson(json)));
  }

  Future<Estudo> detalha(int id) async {
    return await get('/estudo/$id',
        typeMapper: (json) => Estudo.fromJson(json));
  }

}

EstudoApi estudoApi = new EstudoApi();