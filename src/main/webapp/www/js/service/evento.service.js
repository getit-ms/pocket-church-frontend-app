calvinApp.service('eventoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('evento');
        };

        this.busca = function(filtro, callback){
            return this.api().all('proximos').customGET('', filtro).then(callback);
        };

        this.carrega = function(id, callback){
            return this.api().get(id).then(callback);
        };

        this.inscricao = function(evento, inscricoes, success, error){
            this.api().one(evento + '/inscricao').customPOST(inscricoes).then(success, error);
        };

        this.buscaMinhasInscricoes = function(id, filtro, callback){
            this.api().one(id + '/inscricoes/minhas').customGET('', filtro).then(callback);
        };

}]);
