calvinApp.service('votacaoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('votacao');
        };
        
        this.busca = function(filtro, callback){
            return this.api().all('ativas').get('', filtro).then(callback);
        };
        
        this.carrega = function(id, callback){
            return this.api().get(id).then(callback);
        };
        
        this.submete = function(votacao, callback){
            this.api().one('voto').customPOST(votacao).then(callback);
        };
        
}]);
        