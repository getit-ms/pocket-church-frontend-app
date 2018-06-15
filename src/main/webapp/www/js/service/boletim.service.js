calvinApp.service('boletimService', ['Restangular', 'arquivoService', '$q', function(Restangular, arquivoService, $q){
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
                    arquivoService.get(boletins.resultados[0].boletim,
                      function(){}, function(){}, function(){});
                  };

                  deferred.resolve()
                }, deferred.reject);
            }catch(e){
                console.log(e);
                deferred.reject();
            }

            return deferred.promise;
        };
    }]);
