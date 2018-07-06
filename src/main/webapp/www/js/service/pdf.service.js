calvinApp.service('pdfService', ['cacheService', 'arquivoService', 'pdfDAO', '$cordovaFile', '$q', function(cacheService, arquivoService, pdfDAO, $cordovaFile, $q){

  this.init = function(){
    var deferred = $q.defer();

    try{
      $cordovaFile.checkDir(cordova.file.dataDirectory, "pdfs").then(function(){}, function(){
        $cordovaFile.createDir(cordova.file.dataDirectory, "pdfs");
      });

      deferred.resolve();
    }catch(e){
      console.log(e);
      deferred.reject();
    }

    return deferred.promise;
  };

  this.clean = function(){
    var deferred = $q.defer();

    try{

      pdfDAO.recuperaAntigos().then(function(itens) {
        function removeChain(i) {
          if (i < itens.length) {
            var item = itens[i];

            pdfDAO.remove(item.tipo, item.id, item.pagina).then(function() {
              try{
                $cordovaFile.removeFile(cordova.file.dataDirectory, 'pdfs/' + item.hash + '.bin').then(function() {
                  removeChain(i+1);
                }, function() {
                  removeChain(i+1);
                });
              }catch(e){
                console.error(e);

                removeChain(i+1);
              }
            }, function() {
              removeChain(i+1);
            })
          } else {
            deferred.resolve();
          }
        }

        removeChain(0);
      }, function (err) {
        deferred.reject(err);
      });

    }catch(e){
      console.log(e);
      deferred.reject();
    }

    return deferred.promise;
  };

  this.get = function (id, successCallback, errorCallback, progressCallback){
    if (!errorCallback) {
      errorCallback = function(){};
    }

    arquivoService.get(id, function(loaded) {
      if (loaded.success) {
        PDFJS.getDocument(loaded.file).promise.then(function(pdf) {
          successCallback(pdf);
        });
      } else {
        errorCallback();
      }

    }, function(progress){}, function(){
      errorCallback();
    }, progressCallback);
  };

  // O limite garante que o usuário não ficará com o celular lotado por estar visualizando as imagens em zoom
  var LIMITE = 1.5;

  this.getPage = function(tipo, id, page, scale, successCallback, errorCallback) {
    if (!errorCallback) {
      errorCallback = function(){};
    }

    pdfDAO.get(tipo, id, page.pageNumber).then(function(item) {
      if (item) {
        var path = 'pdfs/' + item.hash + '.bin';

        if (item.scale >= scale) {
          pdfDAO.registraUso(tipo, id, page.pageNumber, item.scale);

          successCallback({file:parseFilename(cordova.file.dataDirectory + path, scale)});
        } else {
          successCallback({file:parseFilename(cordova.file.dataDirectory + path, item.scale), temp:true});

          renderPageToFile(page, scale, path, function (url) {
            pdfDAO.registraUso(tipo, id, page.pageNumber, scale > LIMITE ? item.scale : scale);

            successCallback({file:url});
          }, function (err) {
            errorCallback(err);
          });
        }
      } else {
        pdfDAO.cadastra(tipo, id, page.pageNumber, scale).then(function(item) {
          var path = 'pdfs/' + item.hash + '.bin';

          renderPageToFile(page, scale, path, function (url) {
            successCallback({file:url});
          }, function (err) {
            errorCallback(err);
          });
        }, function (err) {
          errorCallback(err);
        })
      }
    }, function(err) {
      errorCallback(err);
    })
  };

  function parseFilename(filename, scale) {
    return filename.replace('file://', '') + '?scl=' + scale;
  }


  function renderPageToFile(page, scale, path, successCallback, errorCallback) {
    if (!errorCallback) {
      errorCallback = function(){};
    }

    var viewport = page.getViewport(scale * 1.2);
    var canvas = document.createElement('canvas');

    // Prepare canvas using PDF page dimensions
    canvas.height = viewport.height;
    canvas.width = viewport.width;

    var context = canvas.getContext('2d');

    // Render PDF page into canvas context
    page.render({
      canvasContext: context,
      viewport: viewport,
      enableWebGL: true,
      intent: 'print'
    }).then(function() {
      var url = canvas.toDataURL("image/jpeg");

      if (scale > LIMITE) {
        successCallback(url);
      } else {
        var base64 = url.replace(/data:image\/[a-z]+;base64,/, '');

        $cordovaFile.writeFile(cordova.file.dataDirectory, path, base64toBlob(base64), true).then(
          function(success){
            successCallback(parseFilename(cordova.file.dataDirectory + path, scale));
          },
          function(error){
            errorCallback(error)
          }
        )
      }

    }, function(err) {
      errorCallback(err);
    });

  };

  function base64toBlob(base64Data, contentType) {
    contentType = contentType || '';
    var sliceSize = 1024;
    var byteCharacters = atob(base64Data);
    var bytesLength = byteCharacters.length;
    var slicesCount = Math.ceil(bytesLength / sliceSize);
    var byteArrays = new Array(slicesCount);

    for (var sliceIndex = 0; sliceIndex < slicesCount; ++sliceIndex) {
      var begin = sliceIndex * sliceSize;
      var end = Math.min(begin + sliceSize, bytesLength);

      var bytes = new Array(end - begin);
      for (var offset = begin, i = 0 ; offset < end; ++i, ++offset) {
        bytes[i] = byteCharacters[offset].charCodeAt(0);
      }
      byteArrays[sliceIndex] = new Uint8Array(bytes);
    }
    return new Blob(byteArrays, { type: contentType });
  }
}]);
