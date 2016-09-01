calvinApp.service('boletimService', ['Restangular', 'pdfService', function(Restangular, pdfService){
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
            this.busca({pagina:1,total:5}, function(boletins){
                pdfService.load('boletim', boletins.resultados);
            });
        };
    }]);
