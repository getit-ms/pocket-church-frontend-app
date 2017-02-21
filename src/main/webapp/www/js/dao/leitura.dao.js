calvinApp.service('leituraDAO', ['database', '$q', function(database, $q){
        this.findUltimaAlteracao  = function(callback){
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT max(ultima_atualizacao) as ultimaAtualizacao FROM leitura_biblica where remoto = ?', [true], function(tx, rs) {
                    if (rs.rows && rs.rows.length){
                        callback(new Date(rs.rows.item(0).ultimaAtualizacao));
                    }else{
                        callback();
                    }
                }, function(tx, error) {
                    callback();
                });
            });
        };

        this.merge = function(leitura){
            database.db.transaction(function(tx) {
                tx.executeSql('delete from leitura_biblica where id_plano <> ?', [leitura.plano]);
                
                var atualiza = function(){
                    tx.executeSql('delete from leitura_biblica where id = ?', [leitura.id]);

                    tx.executeSql('insert into leitura_biblica(id, descricao, data, ultima_atualizacao, lido, sincronizado, id_plano, remoto) values(?,?,?,?,?,?,?,?)',
                    [leitura.dia.id, leitura.dia.descricao, leitura.dia.data.getTime(), leitura.ultimaAlteracao.getTime(), leitura.lido, true, leitura.plano, true]);
                };
                
                tx.executeSql('SELECT ultima_atualizacao as ultimaAtualizacao FROM leitura_biblica where id = ?', [leitura.id], function(tx, rs) {
                    if (rs.rows && rs.rows.length && 
                            leitura.ultimaAlteracao.getTime() < rs.rows.item(0).ultimaAtualizacao){
                        atualiza();
                    }
                }, function(tx, error) {
                    atualiza();
                });
            });
        };

        this.findNaoSincronizados = function(){
            var deferred = $q.defer();
            
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, lido FROM leitura_biblica where sincronizado = ?', [false], function(tx, rs) {
                    var leituras = [];

                    for (var i=0;i<rs.rows.length;i++){
                        var item = rs.rows.item(i);
                        leituras.push({
                            id:item.id,
                            lido:item.lido
                        });
                    }

                    deferred.resolve(leituras);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });

            return deferred.promise;
        };

        this.findRangeDatas = function(){
            var deferred = $q.defer();

            database.db.transaction(function(tx) {
                tx.executeSql('SELECT min(data) as dataInicio, max(data) as dataTermino FROM leitura_biblica', [], function(tx, rs) {
                    if (rs.rows && rs.rows.length){
                        var item = rs.rows.item(0);
                        
                        deferred.resolve({
                          dataInicio:new Date(item.dataInicio),
                          dataTermino:new Date(item.dataTermino)
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
        
        this.findByData = function(data){
            var deferred = $q.defer();

            database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, descricao, lido, data FROM leitura_biblica where data = ?', [data.getTime()], function(tx, rs) {
                    if (rs.rows && rs.rows.length){
                        var item = rs.rows.item(0);
                        
                        deferred.resolve({
                          id:item.id,
                          numero:item.numero,
                          nome:item.nome,
                          assunto:item.assunto,
                          texto:item.texto,
                          autor:item.autor,
                          filename:item.filename
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
        
        this.atualizaLeitura = function(id, lido){
            database.db.transaction(function(tx) {
                tx.executeSql('update leitura_biblica set lido = ?, remoto = ? where id = ?', [lido, false, id]);
            });
        };
        
        this.atualizaSincronizacao = function(id, sincronizado){
            database.db.transaction(function(tx) {
                tx.executeSql('update leitura_biblica set sincronizado = ?, ultima_atualizacao = ? where id = ?', [sincronizado, new Date().getTime(), id]);
            });
        };

    }]);
