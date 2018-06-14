calvinApp.service('pdfService', ['cacheService', 'arquivoService', function(cacheService, arquivoService){
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
    }]);
