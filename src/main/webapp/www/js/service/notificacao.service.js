calvinApp.service('notificacaoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.one('notificacao');
        };
        
        this.busca = function(filtro, callback){
            this.api().get(filtro).then(callback);
        };
        
        this.count = function(success, error){
            return this.api().one('count').get().then(success, error);
        };
        
        this.clear = function(success){
            return this.api().one('clear').remove().then(success);
        };
        
        this.remove = function(id, success){
            return this.api().one('/' + id).remove().then(success);
        };
}]);
        