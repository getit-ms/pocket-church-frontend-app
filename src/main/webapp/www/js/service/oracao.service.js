calvinApp.service('oracaoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('oracao');
        };
        
        this.busca = function(filtro, callback){
            return this.api().all('meus').get('', filtro).then(callback);
        };
        
        this.submete = function(oracao, callback){
            this.api().customPOST(oracao).then(callback);
        };
        
}]);
        