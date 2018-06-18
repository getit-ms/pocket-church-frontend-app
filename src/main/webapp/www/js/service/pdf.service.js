calvinApp.service('pdfService', ['cacheService', 'arquivoService', 'pdfDAO', '$cordovaFile', function(cacheService, arquivoService, pdfDAO, $cordovaFile){

  this.init = function(){
    var deferred = $q.defer();

    try{
      pdfDAO.removeAntigos();

      $cordovaFile.checkDir(cordova.file.tempDirectory, "pdfs").then(function(){}, function(){
        $cordovaFile.createDir(cordova.file.tempDirectory, "pdfs");
      });
    }catch(e){
      console.log(e);
      deferred.reject();
    }

    return deferred.promise;
  };

  this.get = function (id, successCallback, errorCallback){
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

    }, function(){}, function(){
      errorCallback();
    });
  };

  this.getPage = function(tipo, id, page, scale, successCallback, errorCallback) {
    if (!errorCallback) {
      errorCallback = function(){};
    }

    pdfDAO.get(tipo, id, page.pageNumber).then(function(item) {
      if (item) {

        var path = 'pdfs/' + item.hash + '.bin';
        if (item.scale >= scale) {
          $cordovaFile.checkFile(cordova.file.tempDirectory, path).then(function () {
            pdfDAO.registraUso(tipo, id, page.pageNumber, scale);

            successCallback(cordova.file.tempDirectory + path);
          }, function () {
            renderPageToFile(page, scale, path, function () {
              pdfDAO.registraUso(tipo, id, page.pageNumber, scale);

              successCallback(cordova.file.tempDirectory + path);
            }, function (err) {
              errorCallback(err);
            });
          });
        } else {
          renderPageToFile(page, scale, path, function () {
            pdfDAO.registraUso(tipo, id, page.pageNumber, scale);

            successCallback(cordova.file.tempDirectory + path);
          }, function (err) {
            errorCallback(err);
          });
        }
      } else {
        pdfDAO.cadastra(tipo, id, page.pageNumber, scale).then(function(item) {
          renderPageToFile(page, scale, path, function () {
            successCallback(cordova.file.tempDirectory + path);
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
    scope.page.render({
      canvasContext: context,
      viewport: viewport
    }).then(function() {
      var base64 = canvas.toDataURL("image/jpeg").replace(/data:image\/[a-z]+;base64,/, '');

      $cordovaFile.writeFile(cordova.file.tempDirectory, path, base64toBlob(base64), true).then(
        function(success){
          successCallback();
        },
        function(error){
          errorCallback(error)
        }
      )
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
