calvinApp.service('boletimService', ['Restangular', 'pdfService', '$q', function(Restangular, pdfService, $q){
        this.api = function(){
            return Restangular.one('boletim');
        };

        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };

        this.carrega = function(id, callback){
            this.api().one('' + id).get().then(callback);
        };

        this.cache = function(){
            var deferred = $q.defer();
            
            try{
                this.busca({pagina:1,total:5}, function(boletins){
                    pdfService.load('boletim', boletins.resultados);
                    deferred.resolve();
                });
            }catch(e){
                console.log(e);
                deferred.reject();
            }
            
            return deferred.promise;
        };
    }]);
