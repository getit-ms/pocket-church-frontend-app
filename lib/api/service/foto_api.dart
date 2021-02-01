part of pocket_church.api;


class FotoApi extends ApiBase {
  Future<Pagina<GaleriaFotos>> consultaGalerias({
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      '/foto/galeria',
      parameters: {
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper(
            (json) => GaleriaFotos.fromJson(json),
      ),
    );
  }

  Future<Pagina<Foto>> consulta({
    String galeria,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      '/foto/galeria/$galeria',
      parameters: {
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper(
            (json) => Foto.fromJson(json),
      ),
    );
  }

}

final FotoApi fotoApi = new FotoApi();
