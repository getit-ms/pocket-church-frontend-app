part of pocket_church.api;

class HinoApi extends ApiBase {
  Future<Pagina<Hino>> consulta({
    DateTime ultimaAtualizaca,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      "/hino",
      parameters: {
        'ultimaAtualizacao': StringUtil.formatIso(ultimaAtualizaca),
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper((json) => Hino.fromJson(json)),
    );
  }

  Future<Hino> detalha(int hino) async {
    return await get(
      "/hino/$hino",
      typeMapper: (json) => Hino.fromJson(json),
    );
  }
}

HinoApi hinoApi = new HinoApi();
