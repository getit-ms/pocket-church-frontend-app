calvinApp.service('fotoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('foto');
        };

        this.buscaGalerias = function(pagina, callback){
            return this.api().all('galeria').get('', {pagina:pagina}).then(callback);
        };

        this.buscaFotos = function(galeria, pagina, callback){
            return this.api().all('galeria').get('/' + galeria, {pagina:pagina}).then(callback);
        };

}]);
