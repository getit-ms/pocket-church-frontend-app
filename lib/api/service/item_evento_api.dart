part of pocket_church.api;

class ItemEventoApi extends ApiBase {
  Future<Pagina<ItemEvento>> consultaTimeline({
    String filtro,
    int autor,
    bool semAutor,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get('/item-evento/timeline',
        parameters: {
          'filtro': filtro,
          'autor': autor,
          'semAutor': semAutor,
          'pagina': pagina?.toString(),
          'total': tamanhoPagina?.toString()
        },
        typeMapper: paginaTypeMapper((json) => ItemEvento.fromJson(json)));
  }

  Future<List<ItemEvento>> consultaPeriodo({
    DateTime dataInicio,
    DateTime dataTermino,
  }) async {
    String diFormated =
        StringUtil.formatData(dataInicio, pattern: "yyyy-MM-dd");
    String dtFormated =
        StringUtil.formatData(dataTermino, pattern: "yyyy-MM-dd");

    return await get(
      '/item-evento/periodo/$diFormated/$dtFormated',
      typeMapper: listTypeMapper((json) => ItemEvento.fromJson(json)),
    );
  }
  Future<void> like(TipoItemEvento tipo, String id) async {
    await post(
      '/item-evento/${TipoItemEventoSerializer.tipoToString(tipo)}/$id/curtir',
    );
  }

  Future<void> dislike(TipoItemEvento tipo, String id) async {
    await delete(
      '/item-evento/${TipoItemEventoSerializer.tipoToString(tipo)}/$id/curtir',
    );
  }

  Future<Comentario> comenta(
      TipoItemEvento tipo, String id, Comentario comentario) async {
    return await post(
      '/item-evento/${TipoItemEventoSerializer.tipoToString(tipo)}/$id/comentario',
      body: comentario.toJson(),
      typeMapper: (json) => Comentario.fromJson(json),
    );
  }

  Future<Pagina<Comentario>> buscaComentarios(
      TipoItemEvento tipo, String id, int pagina, int tamanhoPagina) async {
    return await get(
      '/item-evento/${TipoItemEventoSerializer.tipoToString(tipo)}/$id/comentario',
      parameters: {
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString()
      },
      typeMapper: paginaTypeMapper((json) => Comentario.fromJson(json)),
    );
  }

  Future<void> removeComentario(int id) async {
    return await delete(
      '/item-evento/comentario/$id',
    );
  }

  Future<void> denunciaComentario(int id, DenunciaComentario denuncia) async {
    await post(
      '/item-evento/comentario/$id/denuncia',
      body: denuncia.toJson(),
    );
  }
}

final ItemEventoApi itemEventoApi = new ItemEventoApi();
