part of pocket_church.api;

class BannerApi extends ApiBase {

  Future<List<Banner>> consulta() async {
    return await get(
      "/banner",
      typeMapper: listTypeMapper((json) => Banner.fromJson(json)),
    );
  }

}

BannerApi bannerApi = BannerApi();
