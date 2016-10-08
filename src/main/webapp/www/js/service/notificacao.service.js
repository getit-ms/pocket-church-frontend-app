calvinApp.service('notificacaoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.one('notificacao');
        };
        
        this.busca = function(filtro, callback){
            this.api().customGET('', filtro).then(callback);
        };
        
        this.count = function(callback){
            return this.api().one('count').get().then(callback);
        };
}]);
        