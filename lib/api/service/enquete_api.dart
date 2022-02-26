part of pocket_church.api;

class EnqueteApi extends ApiBase {
  Future<Pagina<Enquete>> consulta({
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      "/votacao/ativas",
      parameters: {
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper((json) => Enquete.fromJson(json)),
    );
  }

  Future<Enquete> detalha(int id) async {
    return await get(
      "/votacao/$id",
      typeMapper: (json) => Enquete.fromJson(json),
    );
  }

  responde(RespostaEnquete resposta) async {
    await post(
      "/votacao/voto",
      body: resposta.toJson(),
    );
  }

  Future<ResultadoEnquete> resultado(int id) async {
    return await get(
      "/votacao/$id/resultado",
      typeMapper: (json) => ResultadoEnquete.fromJson(json),
    );
  }
}

EnqueteApi enqueteApi = new EnqueteApi();
