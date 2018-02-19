calvinApp.service('estudoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('estudo');
        };

        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };

        this.buscaCategorias = function(callback){
          return this.api().all('categoria').getList().then(callback);
        };

        this.carrega = function(id){
            return this.api().get(id).$object;
        };
}]);
