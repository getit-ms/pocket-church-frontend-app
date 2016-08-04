calvinApp.service('hinoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('hino');
        };
        
        this.busca = function(filtro, callback){
            return this.api().get('', filtro).then(callback);
        };
        
        this.carrega = function(id){
            return this.api().get(id).$object;
        };
}]);
        