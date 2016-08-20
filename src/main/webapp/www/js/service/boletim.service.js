calvinApp.service('boletimService', ['Restangular', 'pdfService', function(Restangular, pdfService){
        this.api = function(){
            return Restangular.one('boletim');
        };

        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };

        this.carrega = function(id, callback){
            var cache = pdfService.getCache('boletim', id);
            if (cache){
                callback(cache.boletim);
            }else{
                this.api().one('' + id).get().then(callback);
            }
        };

        this.verificaNovos = function(){
            this.busca({pagina:1,total:10}, function(boletins){
              pdfService.carregaNovos('boletim', boletins.resultados);
            });
        };

        this.renovaCache = function(){
            pdfService.clearCacheAntigos('boletim');
            this.verificaNovos();
        };
    }]);
