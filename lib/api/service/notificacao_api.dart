part of pocket_church.api;


class NotificacaoApi extends ApiBase {

  Future<Pagina<Notificacao>> consulta({int pagina, int tamanhoPagina}) async {
    return await get('/notificacao',
        parameters: {
          'pagina': pagina?.toString(),
          'total': tamanhoPagina?.toString()
        }, typeMapper: paginaTypeMapper((json) => Notificacao.fromJson(json)));
  }

  Future<void> clear(List<int> excecoes) async {
    return await delete('/notificacao/clear',
        parameters: {
          'excecao': excecoes.map((e) => e.toString()).toList()
        },
    );
  }

  Future<void> remove(int notificacao) async {
    return await delete('/notificacao/$notificacao');
  }

}

final NotificacaoApi notificacaoApi = new NotificacaoApi();