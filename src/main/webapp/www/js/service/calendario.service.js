calvinApp.service('calendarioService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('calendario');
        };

        this.busca = function(filtro, callback){
            return this.api().get('', filtro).then(callback);
        };
}]);
