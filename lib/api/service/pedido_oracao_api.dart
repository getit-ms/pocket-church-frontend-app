part of pocket_church.api;

class PedidoOracaoApi extends ApiBase {
  Future<Pagina<PedidoOracao>> consultaMeus({
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      "/oracao/meus",
      parameters: {
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper((json) => PedidoOracao.fromJson(json)),
    );
  }

  Future<PedidoOracao> submete(PedidoOracao pedido) async {
    return await post(
      "/oracao",
      body: pedido.toJson(),
      typeMapper: (json) => PedidoOracao.fromJson(json),
    );
  }
}

PedidoOracaoApi pedidoOracaoApi = new PedidoOracaoApi();