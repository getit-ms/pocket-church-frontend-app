calvinApp.service('cifraService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('cifra');
        };

        this.busca = function(filtro, callback){
            return this.api().get('', filtro).then(callback);
        };

        this.carrega = function(id, callback){
            this.api().one('' + id).get().then(callback);
        };
    }]);
