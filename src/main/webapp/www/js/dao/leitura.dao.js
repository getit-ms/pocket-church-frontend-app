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
        
        this.mergePlano = function(plano){
            var deferred = $q.defer();
            
            this.findPlano().then(function(salvo){
                database.db.transaction(function(tx) {
                    if (salvo && salvo.id === plano.id){
                        tx.executeSql('update plano_leitura set descricao = ?', [plano.descricao]);
                    }else{
                        tx.executeSql('delete from plano_leitura', []);
                        tx.executeSql('delete from leitura_biblica', []);

                        tx.executeSql('insert into plano_leitura(id, descricao) values(?,?)', [plano.id, plano.descricao]);
                    }
                    deferred.resolve();
                });
            }, deferred.reject);
            
            return deferred.promise;
        };

        this.mergeLeitura = function(leitura){
            database.db.transaction(function(tx) {
                var atualiza = function(){
                    tx.executeSql('delete from leitura_biblica where id = ?', [leitura.dia.id]);

                    tx.executeSql('insert into leitura_biblica(id, descricao, data, ultima_atualizacao, lido, sincronizado, remoto) values(?,?,?,?,?,?,?)',
                    [leitura.dia.id, leitura.dia.descricao, leitura.dia.data.getTime(), leitura.ultimaAlteracao.getTime(), leitura.lido, true, true]);
                };
                
                tx.executeSql('SELECT ultima_atualizacao as ultimaAtualizacao FROM leitura_biblica where id = ?', [leitura.id], function(tx, rs) {
                    if (!rs.rows || !rs.rows.length || 
                            leitura.ultimaAlteracao.getTime() < rs.rows.item(0).ultimaAtualizacao){
                        atualiza();
                    }
                }, function(tx, error) {
                    atualiza();
                });
            });
        };
        
        this.findPlano = function(){
            var deferred = $q.defer();
            
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, descricao FROM plano_leitura', [], function(tx, rs) {
                    if (rs.rows.length){
                        var item = rs.rows.item(0);
                        deferred.resolve({
                            id: item.id,
                            descricao: item.descricao
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

        this.findNaoSincronizados = function(){
            var deferred = $q.defer();
            
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, lido FROM leitura_biblica where sincronizado = ?', [false], function(tx, rs) {
                    var leituras = [];

                    for (var i=0;i<rs.rows.length;i++){
                        var item = rs.rows.item(i);
                        leituras.push({
                            dia: {
                                id:item.id
                            },
                            lido:item.lido === 'true'
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
                            dia:{
                                id:item.id,
                                descricao:item.descricao,
                                data:new Date(item.data)
                            },
                            lido:item.lido === 'true'
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
        
        this.findDatasLidas = function(){
            var deferred = $q.defer();

            database.db.transaction(function(tx) {
                tx.executeSql('SELECT data FROM leitura_biblica where lido = ? order by data', [true], function(tx, rs) {
                    var datas = [];
                    
                    if (rs.rows && rs.rows.length){
                        for (var i=0;i<rs.rows.length;i++){
                            datas.push(new Date(rs.rows.item(i).data));
                        }
                    }
                    
                    deferred.resolve(datas);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });

            return deferred.promise;
        };
        
        var MILLIS_DAY = 1000 * 60 * 60 * 24; 
        
        this.findPorcentagem = function(){
            var deferred = $q.defer();

            database.db.transaction(function(tx) {
                var progresso = {};
                
                tx.executeSql('SELECT count(*) as count FROM leitura_biblica where descricao is not null', [], function(tx, rs) {
                    if (rs.rows && rs.rows.length){
                        var totalGeral = rs.rows.item(0).count;
                        tx.executeSql('SELECT count(*) as count FROM leitura_biblica where lido = ? and descricao is not null', [true], function(tx, rs) {
                            if (rs.rows && rs.rows.length){
                                progresso.porcentagem = Math.ceil((rs.rows.item(0).count / totalGeral) * 100);
                                progresso.concluido = progresso.porcentagem === 100;
                                
                                tx.executeSql('SELECT count(*) as count FROM leitura_biblica where data < ? and descricao is not null', [new Date().getTime() - MILLIS_DAY], function(tx, rs) {
                                    if (rs.rows && rs.rows.length){
                                        var totalAtual = rs.rows.item(0).count;
                                        tx.executeSql('SELECT count(*) as count FROM leitura_biblica where lido = ? and data < ? and descricao is not null', [true, new Date().getTime() - 2 * MILLIS_DAY], function(tx, rs) {
                                            if (rs.rows && rs.rows.length){
                                                progresso.emDia = totalAtual - rs.rows.item(0).count <= 1;
                                                deferred.resolve(progresso);
                                            }
                                        }, function(tx, error) {
                                            deferred.reject(error);
                                        });
                                    }
                                }, function(tx, error) {
                                    deferred.reject(error);
                                });
                            }
                        }, function(tx, error) {
                            deferred.reject(error);
                        });
                    }
                }, function(tx, error) {
                    deferred.reject(error);
                });
                
            });

            return deferred.promise;
        };
        
        this.atualizaLeitura = function(id, lido, callback){
            database.db.transaction(function(tx) {
                tx.executeSql('update leitura_biblica set lido = ?, remoto = ? where id = ?', [lido, false, id], callback);
            });
        };
        
        this.atualizaSincronizacao = function(id, sincronizado){
            database.db.transaction(function(tx) {
                tx.executeSql('update leitura_biblica set sincronizado = ?, ultima_atualizacao = ? where id = ?', [sincronizado, new Date().getTime(), id]);
            });
        };

    }]);
