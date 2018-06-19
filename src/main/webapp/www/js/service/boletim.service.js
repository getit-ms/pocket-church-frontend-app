calvinApp.service('boletimService', ['Restangular', 'arquivoService', 'pdfService', '$q', function(Restangular, arquivoService, pdfService, $q){
        this.api = function(){
            return Restangular.one('boletim');
        };

        this.busca = function(filtro, success, error){
            return this.api().all('publicados').get('', filtro).then(success, error);
        };

        this.carrega = function(id, callback){
            this.api().one('' + id).get().then(callback);
        };

        this.cache = function(){
            var deferred = $q.defer();

            try{
                this.busca({pagina:1,total:1}, function(boletins){
                  if (boletins.resultados && boletins.resultados.length) {
                    var boletim = boletins.resultados[0];

                    pdfService.get(boletim.boletim.id, function(pdf) {

                      function loadPageChain(i) {
                        if (i<=pdf.numPages) {
                          pdf.getPage(i).then(function(page) {
                            pdfService.getPage('boletim', boletim.boletim.id,
                              page, 1, function() {
                              loadPageChain(i + 1);
                              }, function(){
                                loadPageChain(i + 1);
                              });
                          });
                        }
                      }

                    });
                  }

                  deferred.resolve();
                }, deferred.reject);
            }catch(e){
                console.log(e);
                deferred.reject();
            }

            return deferred.promise;
        };
    }]);
