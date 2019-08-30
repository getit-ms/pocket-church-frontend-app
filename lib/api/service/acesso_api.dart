part of pocket_church.api;

enum TipoDispositivo { ANDROID, IOS }

class AcessoApi extends ApiBase {
  Future<Acesso> login({
    String username,
    String password,
    TipoDispositivo tipoDispositivo,
    String versao,
  }) async {
    return await put<Acesso>(
      '/acesso/login',
      body: {
        'username': username,
        'password': password,
        'tipoDispositivo':
            tipoDispositivo == TipoDispositivo.ANDROID ? 'ANDROID_FIREBASE' : 'IPHONE_FIREBASE',
        'version': versao
      },
      typeMapper: (json) => Acesso.fromJson(json),
    );
  }

  logout() async {
    await put("/acesso/logout");
  }

  registerPush({
    String pushkey,
    TipoDispositivo tipoDispositivo,
    String version,
  }) async {
    await post(
      "/acesso/registerPush",
      body: {
        'token': pushkey,
        'tipoDispositivo': tipoDispositivo == TipoDispositivo.ANDROID ? 5 : 6,
        'version': version,
      },
    );
  }

  Future<Acesso> refresh({
    String version,
  }) async {
    return await get(
      "/acesso",
      parameters: {'versao': version},
      typeMapper: (json) => Acesso.fromJson(json),
    );
  }

  Future<Menu> buscaMenu(String versao) async {
    return await get<Menu>(
      '/acesso/menu',
      parameters: {'versao': versao},
      typeMapper: (json) => Menu.fromJson(json),
    );
  }

  Future<Preferencias> buscaPreferencias() async {
    return await get<Preferencias>(
      '/acesso/preferencias',
      typeMapper: (json) => Preferencias.fromJson(json),
    );
  }

  Future<Preferencias> salvaPreferencias(Preferencias preferencias) async {
    return await put<Preferencias>(
      '/acesso/preferencias',
      body: preferencias.toJson(),
      typeMapper: (json) => Preferencias.fromJson(json),
    );
  }

  Future<void> atualizaFoto(Arquivo foto) async {
    await put<dynamic>(
      '/acesso/foto',
      body: foto.toJson(),
    );
  }

  Future<void> atualizaSenha({
    String novaSenha,
    String confirmacaoSenha,
  }) async {
    await put<dynamic>(
      '/acesso/senha/altera',
      body: {
        'novaSenha': novaSenha,
        'confirmacaoSenha': confirmacaoSenha,
      },
    );
  }

  Future<void> solicitaRedefinicaoSenha(String email) async {
    await put('/acesso/senha/redefinir/$email');
  }

  Future<List<Ministerio>> buscaMinisterios() async {
    return await get(
      '/acesso/ministerios',
      typeMapper: listTypeMapper((json) => Ministerio.fromJson(json)),
    );
  }

  Future<List<String>> buscaHorariosVersiculoDiario() async {
    return await get('/acesso/horariosVersiculoDiario');
  }

  Future<List<String>> buscaHorariosLembretesLeitura() async {
    return await get('/acesso/horariosLembretesLeitura');
  }
}

class Acesso {
  Membro membro;
  String auth;
  Menu menu;

  Acesso.fromJson(dynamic json) {
    membro = Membro.fromJson(json['membro']);
    auth = json['auth'];
    menu = Menu.fromJson(json['menu']);
  }
}

final AcessoApi acessoApi = new AcessoApi();
