part of pocket_church.api;

class MembroApi extends ApiBase {
  Future<Pagina<Membro>> consulta({
    String filtro,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      '/membro',
      parameters: {
        'filtro': filtro,
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper(
        (json) => Membro.fromJson(json),
      ),
    );
  }

  Future<List<Membro>> buscaAniversariantes() async {
    return await get(
      '/membro/aniversariantes',
      typeMapper: listTypeMapper(
            (json) => Membro.fromJson(json),
      ),
    );
  }

  Future<Membro> detalha(int id) async {
    return await get('/membro/$id',
        typeMapper: (json) => Membro.fromJson(json));
  }

  Future<Membro> cadastra(Membro membro) async {
    return await post('/membro',
        body: membro.toJson(),
        typeMapper: (json) => Membro.fromJson(json));
  }
}

final MembroApi membroApi = new MembroApi();
