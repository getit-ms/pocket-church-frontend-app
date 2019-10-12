part of pocket_church.infra;

const MILLIS_7_DIAS = 1000 * 60 * 60 * 24 * 7;

class ArquivoService {
  ArquivoApi arquivoApi = new ArquivoApi();

  init() async {
    Directory baseDir = Directory(await _baseDir());

    try {
      if (baseDir.existsSync()) {
        var limite = new DateTime.now().millisecondsSinceEpoch - MILLIS_7_DIAS;
        baseDir.listSync().forEach((f) {
          if (f.statSync().accessed.millisecondsSinceEpoch < limite) {
            f.delete();
          }
        });
      } else {
        await baseDir.create(recursive: true);
      }
    } catch (ex) {
      print(
          "Falha ao carregar arquivos. Removendo existentes e criando nova estrutura: $ex");

      await baseDir.delete(recursive: true);

      await baseDir.create(recursive: true);
    }
  }

  Future<String> _baseDir() async {
    var base = await getApplicationDocumentsDirectory();
    return "${base.uri.path.replaceAll(RegExp('\/?[^\/]*flutter[^\/]*'), "")}arquivos";
  }

  Future<String> _tmpDir() async {
    var base = await getTemporaryDirectory();
    var path =
        "${base.uri.path.replaceAll(RegExp('\/?[^\/]*flutter[^\/]*'), "")}tmp";
    var dir = Directory(path);

    if (!dir.existsSync()) {
      dir.create(recursive: true);
    }

    return path;
  }

  Future<String> get tempDir async {
    return await _tmpDir();
  }

  _tempFile(int idArquivo) async {
    String basePath = await _tmpDir();
    return File(
        "$basePath/${DateTime.now().millisecondsSinceEpoch}.$idArquivo.bin");
  }

  _file(int idArquivo) async {
    String basePath = await _baseDir();

    return File("$basePath/$idArquivo.bin");
  }

  getFileLocation(int idArquivo) async {
    return await _file(idArquivo);
  }

  _downloadFile(int idArquivo, {ProgressCallback onProgress}) async {
    File tempFile = await _tempFile(idArquivo);

    await arquivoApi.downloadArquivo(idArquivo, tempFile.path,
        onProgress: onProgress);

    File file = await _file(idArquivo);

    if (!file.parent.existsSync()) {
      file.parent.createSync();
    }

    tempFile.rename(file.path);
  }

  Future<Arquivo> uploadFile(String filePath,
      {ProgressCallback onProgress}) async {
    return await arquivoApi.uploadArquivo(filePath, onProgress: onProgress);
  }

  Future<String> selecionaImagem() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    return file.path;
  }

  Future<String> tiraFoto() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    return file.path;
  }

  Future<File> getFile(int idArquivo, {ProgressCallback onProgress}) async {
    File file = await _file(idArquivo);

    if (file == null || !file.existsSync()) {
      await _downloadFile(idArquivo, onProgress: onProgress);
    }

    return await _file(idArquivo);
  }

  Future<String> downloadTemp(String url, {ProgressCallback onProgress}) async {
    Directory dir = await getTemporaryDirectory();

    File file = new File(
        dir.path + "/" + DateTime.now().millisecondsSinceEpoch.toString());

    await arquivoApi.downloadFromURL(url, file.path, onProgress: onProgress);

    return file.path;
  }
}

ArquivoService arquivoService = ArquivoService();
