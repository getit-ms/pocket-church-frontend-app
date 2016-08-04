calvinApp.service('eventoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('evento');
        };
        
        this.busca = function(filtro, callback){
            return this.api().all('proximos').get('', filtro).then(callback);
        };
        
        this.carrega = function(id, callback){
            return this.api().get(id).then(callback);
        };
        
        this.inscricao = function(evento, inscricoes, callback){
            this.api().one(evento + '/inscricao').customPOST(inscricoes).then(callback);
        };
        
        this.buscaMinhasInscricoes = function(id, filtro, callback){
            this.api().one(id + '/inscricoes/minhas').customGET('', filtro).then(callback);
        };
        
}]);
        