part of pocket_church.api;

class ArquivoApi extends ApiBase {
  Future<void> downloadArquivo(
    int id,
    String pathTo, {
    ProgressCallback onProgress,
  }) async {
    await download(
      "/arquivo/download/$id",
      pathTo,
      onProgress: onProgress,
    );
  }

  Future<Arquivo> uploadArquivo(String filePath,
      {ProgressCallback onProgress}) async {
    return await upload<Arquivo>(
      "/arquivo/upload",
      filePath,
      onProgress: onProgress,
      typeMapper: (json) => Arquivo.fromJson(json),
    );
  }
}
