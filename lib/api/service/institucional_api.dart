part of pocket_church.api;

class InstitucionalApi extends ApiBase {

  Future<Institucional> consulta() async {
    return await get<Institucional>('/institucional',
        typeMapper: (json) => Institucional.fromJson(json));
  }

}