part of pocket_church.api;

class ChamadoApi extends ApiBase {
  Future<Pagina<Sugestao>> consultaMeus({
    int pagina,
    int tamanhoPagina,
  }) async {
    return get(
      "/chamado",
      parameters: {
        'pagina': pagina?.toString(),
        'total': pagina?.toString(),
      },
      typeMapper: paginaTypeMapper((json) => Sugestao.fromJson(json)),
    );
  }

  Future<Sugestao> cadastra(Sugestao sugestao) async {
    return post(
      "/chamado",
      body: sugestao.toJson(),
      typeMapper: (json) => Sugestao.fromJson(json),
    );
  }
}

ChamadoApi chamadoApi = new ChamadoApi();
