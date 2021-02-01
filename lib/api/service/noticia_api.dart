part of pocket_church.api;

class NoticiaApi extends ApiBase {

  Future<Pagina<Noticia>> consulta({int pagina, int tamanhoPagina}) async {
    return await get('/noticia/publicados',
        parameters: {
          'pagina': pagina?.toString(),
          'total': tamanhoPagina?.toString()
        }, typeMapper: paginaTypeMapper((json) => Noticia.fromJson(json)));
  }

  Future<Noticia> detalha(int id) async {
    return await get('/noticia/$id',
        typeMapper: (json) => Noticia.fromJson(json));
  }

}

final NoticiaApi noticiaApi = new NoticiaApi();