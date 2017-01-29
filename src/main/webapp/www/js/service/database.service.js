calvinApp.service('databaseService', ['$ionicPlatform', '$q', function($ionicPlatform, $q){
        $ionicPlatform.on("deviceready", function () {
            this.db = window.sqlitePlugin.openDatabase({name: 'pocket-church.db', location: 'default'});
            
            this.db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS livro_biblia(id, nome, ordem, abreviacao, ultima_atualizacao, testamento)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS versiculo_biblia(id, capitulo, versiculo, texto, id_livro)');
            });
        });
        
        this.findUltimaAlteracaoLivroBiblia = function(callback){
            this.db.transaction(function(tx) {
                tx.executeSql('SELECT max(ultima_alteracao) as ultimaAlteracao FROM livro_biblia', [], function(tx, rs) {
                    if (rs.rows && rs.rows.length){
                        callback(rs.rows.item(0).ultimaAlteracao);
                    }else{
                        callback(undefined);
                    }
                }, function(tx, error) {
                    callback(undefined);
                });
            });
        };
        
        this.mergeLivroBiblia = function(livro){
            this.db.transaction(function(tx) {
                tx.executeSql('delete from versiculo_biblia where id_livro = ?', [livro.id]);
                tx.executeSql('delete from livro_biblia where id = ?', [livro.id]);
                
                tx.executeSql('insert into livro_biblia(id, nome, ordem, abreviacao, ultima_alteracao, testamento) values(?,?,?,?,?,?)',
                    [livro.id, livro.nome, livro.ordem, livro.abreviacao, livro.ultimaAlteracao, livro.testamento]);
                
                livro.versiculos.forEach(function(versiculo){
                    tx.executeSql('insert into versiculo_biblia(id, capitulo, versiculo, texto, id_livro) values(?,?,?,?,?)',
                        [versiculo.id, versiculo.capitulo, versiculo.versiculo, versiculo.texto, livro.id]);
                });
            });
        };
        
        this.findLivrosBibliaByTestamento = function(testamento){
            var deferred = $q.defer();
            
            this.db.transaction(function(tx) {
                tx.executeSql('SELECT * FROM livro_biblia where testamento = ? order by ordem', [testamento], function(tx, rs) {
                    var livros = [];
                    
                    for (var i=0;i<rs.rows.length;i++){
                        var item = rs.rows.item(i);
                        livros.push({
                            id:item.id,
                            nome:item.nome
                        });
                    }
                    
                    deferred.resolve(livros);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });
            
            return deferred.resolve;
        };
        
        this.findCapitulosLivroBiblia = function(livro){
            var deferred = $q.defer();
            
            this.db.transaction(function(tx) {
                tx.executeSql('SELECT capitulo as capitulo FROM versiculo_biblia where id_livro = ? group by capitulo order by capitulo', [livro], function(tx, rs) {
                    var capitulos = [];
                    
                    for (var i=0;i<rs.rows.length;i++){
                        capitulos.push(rs.rows.item(i).capitulo);
                    }
                    
                    deferred.resolve(capitulos);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });
            
            return deferred.resolve;
        };
        
        this.findLivroBiblia = function(livro){
            var deferred = $q.defer();
            
            this.db.transaction(function(tx) {
                tx.executeSql('SELECT * FROM livro_biblia where id = ?', [livro], function(tx, rs) {
                    if (rs.rows.length){
                        var item = rs.rows.item(0);
                        deferred.resolve({
                            id: item.id,
                            nome: item.nome,
                            abreviacao: item.abreviacao
                        });
                    }else{
                        deferred.resolve(null);
                    }
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });
            
            return deferred.resolve;
        };
        
        this.findVersiculosByLivroCapituloBiblia = function(livro, capitulo){
            var deferred = $q.defer();
            
            this.db.transaction(function(tx) {
                tx.executeSql('SELECT * FROM versiculo_biblia where id_livro = ? and capitulo = ? order by versiculo', [livro, capitulo], function(tx, rs) {
                    var versiculos = [];
                    
                    for (var i=0;i<rs.rows.length;i++){
                        var item = rs.rows.item(i);
                        versiculos.push({
                            id: item.id,
                            capitulo: item.capitulo,
                            versiculo: item.versiculo,
                            texto: item.texto
                        });
                    }
                    
                    deferred.resolve(versiculos);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });
            
            return deferred.resolve;
        };
        
    }]);
