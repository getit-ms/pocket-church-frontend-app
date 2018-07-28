calvinApp.service('agendaService', ['Restangular', '$filter', function(Restangular, $filter){
        this.api = function(){
            return Restangular.one('audio');
        };

        this.busca = function(filtro, callback){
            return this.api().customGET('', filtro).then(callback);
        };

        this.buscaCategorias = function(callback){
            return this.api().all('categoria').getList().then(callback);
        };

}]);
