part of pocket_church.api;

class AssetsApi extends ApiBase {

  Future<Map<String, dynamic>> buscaPorLocale(String locale) async {
    return await get<Map<String, dynamic>>('/assets/i18n/locale/$locale.json');
  }

  Future<Map<String, dynamic>> buscaPorIgreja(String igreja) async {
    return await get<Map<String, dynamic>>('/assets/i18n/igreja/$igreja.json');
  }

}
