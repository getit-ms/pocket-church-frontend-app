part of pocket_church.api;


class AudioApi extends ApiBase {

  Future<List<CategoriaAudio>> consultaCategorias() async {
    return await get('/audio/categoria',
        typeMapper: listTypeMapper((json) => CategoriaAudio.fromJson(json)));
  }

  Future<Pagina<Audio>> consulta({int categoria, int pagina, int tamanhoPagina}) async {
    return await get('/audio',
        parameters: {
          'categoria': categoria?.toString(),
          'pagina': pagina?.toString(),
          'total': tamanhoPagina?.toString()
        }, typeMapper: paginaTypeMapper((json) => Audio.fromJson(json)));
  }

  Future<Audio> detalha(int id) async {
    return await get('/audio/$id',
        typeMapper: (json) => Audio.fromJson(json));
  }

}

AudioApi audioApi = new AudioApi();