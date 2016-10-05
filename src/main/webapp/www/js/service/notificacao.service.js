calvinApp.service('notificacaoService', ['$window', function($window){
        this.add = function(notificacao){
            var val = this.get();
            val.splice(0, 0, notificacao);
            if (val.length > 50){
                val.splice(50, val.length - 50);
            }
            $window.localStorage.setItem('notificacoes.messages', angular.toJson(val));
			this.count(this.count() + 1);
        };
        
        this.get = function(){
            var val = angular.fromJson($window.localStorage.getItem('notificacoes.messages'));
            if (!val){
                return [];
            }
            return val;
        };
        
        this.count = function(val){
            if (!angular.isUndefined(val)){
                $window.localStorage.setItem('notificacoes.count', angular.toJson({count:val}));
            }
            
            val = angular.fromJson($window.localStorage.getItem('notificacoes.count'));
            if (!val) return 0;
            return val.count;
        };
        
}]);
        