calvinApp.service('boletimService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.one('boletim');
        };

        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };

        this.carrega = function(id, callback){
            this.api().one('' + id).get().then(callback);
        };

    }]);
