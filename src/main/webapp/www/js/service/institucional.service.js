calvinApp.service('institucionalService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.one('institucional');
        };
        
        this.carrega = function(callback){
            this.api().get('').then(callback);
        };
}]);
        