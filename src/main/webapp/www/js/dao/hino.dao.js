calvinApp.service('hinoDAO', ['database', '$q', function(database, $q){
        this.findUltimaAlteracaoHinos  = function(callback){
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT max(ultima_atualizacao) as ultimaAtualizacao FROM hino', [], function(tx, rs) {
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

        this.mergeHino = function(hino){
            database.db.transaction(function(tx) {
                tx.executeSql('delete from hino where id = ?', [hino.id]);

                tx.executeSql('insert into hino(id, numero, assunto, autor, nome, texto, ultima_atualizacao) values(?,?,?,?,?,?,?)',
                [hino.id, hino.numero, hino.assunto, hino.autor, hino.nome, hino.texto, hino.ultimaAlteracao.getTime()]);
            });
        };

        this.findHinosByFiltro = function(filtro){
            filtro = '%' + filtro + '%';

            var deferred = $q.defer();

            database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, numero, nome FROM hino where assunto like ? or nome like ? or texto like ? or autor like ? order by numero', [filtro, filtro, filtro, filtro], function(tx, rs) {
                    var hinos = [];

                    for (var i=0;i<rs.rows.length;i++){
                        var item = rs.rows.item(i);
                        hinos.push({
                            id:item.id,
                            numero:item.numero,
                            nome:item.nome
                        });
                    }

                    deferred.resolve(hinos);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });

            return deferred.promise;
        };

        this.findHino = function(hino){
            var deferred = $q.defer();

            database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, numero, nome, assunto, texto, autor FROM hino where id = ?', [Number(hino)], function(tx, rs) {
                    var hinos = [];

                    for (var i=0;i<rs.rows.length;i++){
                        var item = rs.rows.item(i);
                        hinos.push({
                          id:item.id,
                          numero:item.numero,
                          nome:item.nome,
                          assunto:item.assunto,
                          texto:item.texto,
                          autor:item.autor
                        });
                    }

                    deferred.resolve(hinos);
                }, function(tx, error) {
                    deferred.reject(error);
                });
            });

            return deferred.promise;
        };

    }]);
