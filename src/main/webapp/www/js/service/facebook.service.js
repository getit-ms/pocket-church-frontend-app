calvinApp.service('facebookService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('facebook/video');
        };

        this.busca = function(callback){
            return this.api().getList().then(callback);
        };
}]);