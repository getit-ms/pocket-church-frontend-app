part of pocket_church.api;

typedef ProgressCallback(int received, int total);
typedef ErrorHandler = void Function(
    HttpClientRequest req, HttpClientResponse resp);
typedef TypeMapper<T> = T Function(dynamic json);

class GeneralApiConfig {
  String basePath = "http://localhost:8080/";
  Map<String, String> defaultHeaders = Map();
  List<ErrorHandler> errorHandlers = [];
}

GeneralApiConfig apiConfig = GeneralApiConfig();

abstract class ApiBase {
  dio.Dio _dio = new dio.Dio();
  HttpClient client = new HttpClient();

  Future<T> get<T>(
    String path, {
    Map<String, dynamic> parameters,
    TypeMapper<T> typeMapper,
    Map<String, String> headers,
  }) async {
    return await _handle(
      client.getUrl(Uri.parse(_parseURL(
        path,
        parameters: parameters,
      ))),
      typeMapper: typeMapper,
    );
  }

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic> parameters,
    TypeMapper<T> typeMapper,
    Map<String, String> headers,
  }) async {
    return await _handle(
      client.deleteUrl(Uri.parse(_parseURL(
        path,
        parameters: parameters,
      ))),
      typeMapper: typeMapper,
    );
  }

  Future<T> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic> parameters,
    TypeMapper<T> typeMapper,
    Map<String, String> headers,
  }) async {
    return await _handle(
      client.putUrl(Uri.parse(_parseURL(
        path,
        parameters: parameters,
      ))),
      body: body,
      typeMapper: typeMapper,
    );
  }

  Future<T> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic> parameters,
    TypeMapper<T> typeMapper,
    Map<String, String> headers,
  }) async {
    return await _handle(
      client.postUrl(Uri.parse(_parseURL(
        path,
        parameters: parameters,
      ))),
      body: body,
      typeMapper: typeMapper,
    );
  }

  Future<T> _handle<T>(
    Future<HttpClientRequest> future, {
    dynamic body,
    TypeMapper<T> typeMapper,
    Map<String, String> headers,
  }) async {
    try {
      HttpClientRequest req = await future;

      _parseHeaders(headers).forEach(req.headers.add);

      if (body != null) {
        req.headers.add("Content-Type", "application/json");
        req.write(json.encode(body));
      }

      HttpClientResponse resp = await req.close();

      if (resp.statusCode >= 400) {
        apiConfig.errorHandlers.forEach((eh) => eh(req, resp));

        var body = await parseBody(resp);

        throw new ApiException(
          "${resp.statusCode}: $body",
          request: req,
          response: resp,
          data: body,
        );
      }

      if (resp.statusCode != 204) {
        var body = await parseBody(resp);

        if (body != null && typeMapper != null) {
          return typeMapper(body);
        }
      }
    } catch (ex) {
      print(ex.toString());

      throw ex;
    }

    return null;
  }

  Future parseBody(HttpClientResponse resp) async {
    var completer = new Completer();
    var contents = new StringBuffer();
    resp.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));

    final String str = await completer.future;

    if (str.isEmpty) {
      return null;
    }

    return jsonDecode(str);
  }

  Future<dio.Response> download(
    String path,
    String pathTo, {
    Map<String, String> parameters,
    ProgressCallback onProgress,
    Map<String, String> headers,
  }) async {
    return await _dio.download(
      _parseURL(path, parameters: parameters),
      pathTo,
      options: dio.Options(
        headers: _parseHeaders(headers),
      ),
      onReceiveProgress: onProgress,
    );
  }

  Future<dio.Response> downloadFromURL(
      String url,
      String pathTo, {
        ProgressCallback onProgress,
        Map<String, String> headers,
      }) async {
    return await _dio.download(
      url,
      pathTo,
      options: dio.Options(
        headers: _parseHeaders(headers),
      ),
      onReceiveProgress: onProgress,
    );
  }

  Future<T> upload<T>(
    String path,
    String filePath, {
    TypeMapper<T> typeMapper,
    Map<String, String> parameters,
    ProgressCallback onProgress,
    Map<String, String> headers,
    dio.ResponseType responseType = dio.ResponseType.json,
  }) async {
    dio.FormData formData = new dio.FormData.from({
      "file": new dio.UploadFileInfo(
        new File(filePath),
        filePath.substring(filePath.lastIndexOf("/") + 1),
      )
    });

    var response = await _dio.post(
      _parseURL(path, parameters: parameters),
      data: formData,
      options: dio.Options(
        headers: _parseHeaders(headers),
        responseType: responseType,
      ),
      onSendProgress: onProgress,
    );

    if (response.data != null && typeMapper != null) {
      return typeMapper(response.data);
    }

    return null;
  }

  _parseURL(String path, {Map<String, dynamic> parameters}) {
    return "${apiConfig.basePath}$path${_parseQueryParameters(parameters)}";
  }

  _parseHeaders(Map<String, String> headers) {
    Map<String, String> allHeaders = {};

    allHeaders.addAll(apiConfig.defaultHeaders);

    if (headers != null) {
      allHeaders.addAll(headers);
    }

    return allHeaders;
  }

  _parseQueryParameters(Map<String, dynamic> parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      return "?" +
          parameters.keys
              .map((k) {
                if (parameters[k] is String) {
                  return "$k=${parameters[k]}";
                } else if (parameters[k] is List) {
                  return (parameters[k] as List<String>)
                      .map((s) => "$k=$s")
                      .join("&");
                }

                return null;
              })
              .where((p) => p != null && p.isNotEmpty)
              .join("&");
    }

    return "";
  }
}

TypeMapper<List<T>> listTypeMapper<T>(TypeMapper<T> specificTypeMapper) {
  return (listJson) {
    if (listJson == null) return [];

    return (listJson as List<dynamic>)
        .map((o) => o as Map<String, dynamic>)
        .map(specificTypeMapper)
        .toList();
  };
}

TypeMapper<Pagina<T>> paginaTypeMapper<T>(TypeMapper<T> specificTypeMapper) {
  return (paginaJson) {
    return Pagina<T>(
        resultados:
            listTypeMapper(specificTypeMapper)(paginaJson['resultados']),
        pagina: paginaJson['pagina'],
        hasProxima: paginaJson['hasProxima'],
        totalPaginas: paginaJson['totalPaginas'],
        totalResultados: paginaJson['totalResultados']);
  };
}

class ApiException implements Exception {
  dynamic message;
  dynamic data;
  HttpClientRequest request;
  HttpClientResponse response;

  ApiException(this.message, {this.data, this.request, this.response});

  String toString() {
    return "ApiException: $message. data: $data, request: $request, response: $response";
  }
}
