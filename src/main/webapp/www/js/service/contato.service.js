calvinApp.service('contatoService', ['Restangular', function(Restangular){
        this.api = function(){
            return Restangular.all('membro');
        };

        this.busca = function(filtro, callback){
            return this.api().get('', filtro).then(callback);
        };

        this.buscaAniversariantes = function(callback) {
          return this.api().all('aniversariantes').getList().then(callback);
        };

        this.carrega = function(id){
            return this.api().get(id).$object;
        };

        this.cadastra = function(usuario, success, error){
          this.api().customPUT({
            nome: usuario.nome,
            email: usuario.email,
            telefones: usuario.telefone ? [usuario.telefone] : usuario.telefone,
          }).then(success, error);
        };

        this.carregaCallback = function(id, callback){
          return this.api().get(id).then(callback);
        };
}]);
