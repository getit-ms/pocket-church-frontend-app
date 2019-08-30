part of pocket_church.api;

class VideoApi extends ApiBase {

  Future<List<Video>> consulta() async {
    return await get('/youtube',
        typeMapper: listTypeMapper((json) => Video.fromJson(json)));
  }

}

final VideoApi videoApi = new VideoApi();