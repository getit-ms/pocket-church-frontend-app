calvinApp.service('database', ['$q', function($q){
	  var vm = this;

    this.init = function () {
        var deferred = $q.defer();
        
        try{
            vm.db = window.sqlitePlugin.openDatabase({
              name: 'pocket-church.db',
              location: 'default'
            });

            vm.db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS livro_biblia(id, nome, ordem, abreviacao, ultima_atualizacao, testamento)');
                tx.executeSql('CREATE INDEX IF NOT EXISTS idx_id_livro_biblia ON livro_biblia(id)');
                tx.executeSql('CREATE INDEX IF NOT EXISTS idx_testamento_livro_biblia ON livro_biblia(testamento)');
                
                tx.executeSql('CREATE TABLE IF NOT EXISTS versiculo_biblia(id, capitulo, versiculo, texto, id_livro)');
                tx.executeSql('CREATE INDEX IF NOT EXISTS idx_id_livro_versiculo_biblia ON versiculo_biblia(id_livro)');
                
                tx.executeSql('CREATE TABLE IF NOT EXISTS hino(id, nome, assunto, autor, texto, numero, filename, ultima_atualizacao)');
                tx.executeSql('CREATE INDEX IF NOT EXISTS idx_id_hino ON hino(id)');
                
                tx.executeSql('CREATE TABLE IF NOT EXISTS plano_leitura(id, descricao)');
                
                tx.executeSql('CREATE TABLE IF NOT EXISTS leitura_biblica(id, descricao, data, lido, sincronizado, ultima_atualizacao, id_plano, remoto)');
                tx.executeSql('CREATE INDEX IF NOT EXISTS idx_id_leitura_biblia ON leitura_biblica(id)');
                tx.executeSql('CREATE INDEX IF NOT EXISTS idx_data_leitura_biblia ON leitura_biblica(data)');
                
                deferred.resolve();
            }, function(){
                deferred.reject();
            });
            
        }catch(e){
            console.log(e);
            deferred.reject();
        }
        
        return deferred.promise;
    };

}]);
