part of pocket_church.api;

class IgrejaApi extends ApiBase {

  Future<TemplateAplicativo> buscaTemplate() async {
    return await get<TemplateAplicativo>('/igreja/template-app',
        typeMapper: (json) => TemplateAplicativo.fromJson(json));
  }

}
