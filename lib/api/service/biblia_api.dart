part of pocket_church.api;

class BibliaApi extends ApiBase {
  Future<Pagina<LivroBiblia>> consulta({
    DateTime ultimaAtualizacao,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      "/biblia",
      parameters: {
        'ultimaAtualizacao': StringUtil.formatIso(ultimaAtualizacao),
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper((json) => LivroBiblia.fromJson(json)),
    );
  }
}

BibliaApi bibliaApi = new BibliaApi();
