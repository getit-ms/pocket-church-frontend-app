calvinApp.service('bibliaDAO', ['database', '$q', function(database, $q){
        this.findUltimaAlteracaoLivroBiblia  = function(callback){
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT max(ultima_atualizacao) as ultimaAtualizacao FROM livro_biblia', [], function(tx, rs) {
                    if (rs.rows && rs.rows.length){
                        callback(new Date(rs.rows.item(0).ultimaAtualizacao));
                    }else{
                        callback(undefined);
                    }
                }, function(tx, error) {
                    callback(undefined);
                });
            });
        };
        
        this.mergeLivroBiblia = function(livro){
            database.db.transaction(function(tx) {
                tx.executeSql('delete from versiculo_biblia where id_livro = ?', [livro.id]);
                tx.executeSql('delete from livro_biblia where id = ?', [livro.id]);
                
                tx.executeSql('insert into livro_biblia(id, nome, ordem, abreviacao, ultima_atualizacao, testamento) values(?,?,?,?,?,?)',
                [livro.id, livro.nome, livro.ordem, livro.abreviacao, livro.ultimaAtualizacao.getTime(), livro.testamento]);
                
                livro.versiculos.forEach(function(versiculo){
                    tx.executeSql('insert into versiculo_biblia(id, capitulo, versiculo, texto, id_livro) values(?,?,?,?,?)',
                    [versiculo.id, versiculo.capitulo, versiculo.versiculo, versiculo.texto, livro.id]);
                });
            });
        };
        
        this.findLivrosBibliaByTestamento = function(testamento){
            var deferred = $q.defer();
            
            database.db.transaction(function(tx) {
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
            
            return deferred.promise;
        };
        
        this.findCapitulosLivroBiblia = function(livro){
            var deferred = $q.defer();
            
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT capitulo as capitulo FROM versiculo_biblia where id_livro = ? group by capitulo order by capitulo', [Number(livro)], function(tx, rs) {
                    var capitulos = [];
                    
                    for (var i=0;i<rs.rows.length;i++){
                        capitulos.push(rs.rows.item(i).capitulo);
                    }
                    
                    deferred.resolve(capitulos);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });
            
            return deferred.promise;
        };
        
        this.findLivroBiblia = function(livro){
            var deferred = $q.defer();
            
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT * FROM livro_biblia where id = ?', [Number(livro)], function(tx, rs) {
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
            
            return deferred.promise;
        };
        
        this.findVersiculosByLivroCapituloBiblia = function(livro, capitulo){
            var deferred = $q.defer();
            
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT * FROM versiculo_biblia where id_livro = ? and capitulo = ? order by versiculo', [Number(livro), Number(capitulo)], function(tx, rs) {
                    var versiculos = [];
                    
                    for (var i=0;i<rs.rows.length;i++){
                        var item = rs.rows.item(i);
                        versiculos.push({
                            id: item.id,
                            versiculo: item.versiculo,
                            texto: item.texto
                        });
                    }
                    
                    deferred.resolve(versiculos);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });
            
            return deferred.promise;
        };
        
    }]);
