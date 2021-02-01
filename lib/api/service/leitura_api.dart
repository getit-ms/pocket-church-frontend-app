part of pocket_church.api;

class LeituraApi extends ApiBase {
  Future<Pagina<PlanoLeitura>> consultaPlanos({
    DateTime dataInicio,
    DateTime dataTermino,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      '/planoLeitura',
      parameters: {
        'dataInicio': StringUtil.formatIso(dataInicio),
        'dataTermino': StringUtil.formatIso(dataTermino),
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString(),
      },
      typeMapper: paginaTypeMapper(
        (json) => PlanoLeitura.fromJson(json),
      ),
    );
  }

  Future<Pagina<Leitura>> selecionaPlano(int planoLeitura) async {
    return await put(
      '/planoLeitura/leitura/$planoLeitura',
      typeMapper: paginaTypeMapper((json) => Leitura.fromJson(json)),
    );
  }

  Future<PlanoLeitura> buscaPlanoLeituraSelecionado() async {
    return await get(
      "/planoLeitura/leitura/plano",
      typeMapper: (json) => PlanoLeitura.fromJson(json),
    );
  }

  Future<Pagina<Leitura>> buscaLeituraSelecionada({
    DateTime ultimaAtualizacao,
    int pagina,
    int tamanhoPagina,
  }) async {
    return await get(
      "/planoLeitura/leitura",
      parameters: {
        'ultimaAtualizacao': StringUtil.formatIso(ultimaAtualizacao),
        'pagina': pagina?.toString(),
        'total': tamanhoPagina?.toString()
      },
      typeMapper: paginaTypeMapper((json) => Leitura.fromJson(json)),
    );
  }

  desselecionaPlano() async {
    await delete("/planoLeitura/leitura");
  }

  marcaLeitura(int dia, bool lido) async {
    if (lido) {
      await put("/planoLeitura/leitura/dia/$dia");
    } else {
      await delete("/planoLeitura/leitura/dia/$dia");
    }
  }
}

LeituraApi leituraApi = LeituraApi();
