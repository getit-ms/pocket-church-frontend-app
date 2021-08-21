part of pocket_church.api;

class TermoAceiteApi extends ApiBase {
  Future<TermoAceite> buscaAtual() async {
    return await get('/termo-aceite',
        typeMapper: (json) => TermoAceite.fromJson(json),
    );
  }

  Future<void> aceitaTermo() async {
    await post('/termo-aceite/aceite');
  }
}

final TermoAceiteApi termoAceiteApi = new TermoAceiteApi();
