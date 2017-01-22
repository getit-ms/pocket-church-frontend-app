calvinApp.service('youtubeService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('youtube');
        };
        
        this.busca = function(callback){
            return this.api().getList().then(callback);
        };
}]);
        