calvinApp.service('cifraService', ['Restangular', 'pdfService', function(Restangular, pdfService){
        this.api = function(){
            return Restangular.one('cifra');
        };

        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };

        this.carrega = function(id, callback){
            this.api().one('' + id).get().then(callback);
        };

        this.renovaCache = function(){
            pdfService.clearCacheAntigos('cifra');
        };
    }]);
