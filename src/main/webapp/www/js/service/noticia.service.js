calvinApp.service('noticiaService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('noticia');
        };

        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };

        this.carrega = function(id, callback){
            return this.api().get(id).then(callback);
        };
}]);
