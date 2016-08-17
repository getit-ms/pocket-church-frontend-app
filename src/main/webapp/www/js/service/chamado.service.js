calvinApp.service('chamadoService', ['Restangular', '$filter', function(Restangular, $filter){
        this.api = function(){
            return Restangular.one('chamado');
        };

        this.busca = function(filtro, callback){
            return this.api().get('', filtro).then(callback);
        };

        this.cadastra = function(chamado, callback){
            this.api().customPOST(chamado).then(callback);
        };
}]);
