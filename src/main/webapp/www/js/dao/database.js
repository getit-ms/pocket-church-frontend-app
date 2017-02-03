calvinApp.service('database', [function(){
	  var vm = this;

    this.init = function () {
        vm.db = window.sqlitePlugin.openDatabase({
          name: 'pocket-church.db',
          location: 'default'
        });

        vm.db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS livro_biblia(id, nome, ordem, abreviacao, ultima_atualizacao, testamento)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS versiculo_biblia(id, capitulo, versiculo, texto, id_livro)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS hino(id, nome, assunto, autor, texto, numero, ultima_atualizacao)');
        });
    };

}]);
