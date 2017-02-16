calvinApp.service('hinoDAO', ['database', '$q', function(database, $q){
        this.findUltimaAlteracaoHinos  = function(callback){
            database.db.transaction(function(tx) {
                tx.executeSql('SELECT max(ultima_atualizacao) as ultimaAtualizacao FROM hino', [], function(tx, rs) {
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

        this.mergeHino = function(hino){
            database.db.transaction(function(tx) {
                tx.executeSql('delete from hino where id = ?', [hino.id]);

                tx.executeSql('insert into hino(id, numero, assunto, autor, nome, texto, filename, ultima_atualizacao) values(?,?,?,?,?,?,?,?)',
                [hino.id, hino.numero, hino.assunto, hino.autor, hino.nome, hino.texto, hino.filename, hino.ultimaAlteracao.getTime()]);
            });
        };

        this.findHinosByFiltro = function(filtro){
            var deferred = $q.defer();
            
            filtro = angular.extend({filtro:'',pagina:1,total:50}, filtro);

            database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, numero, nome FROM hino where (numero || nome || texto) like ? order by numero, nome limit ?, ?', 
                            ['%' + filtro.filtro + '%', (filtro.pagina - 1) * filtro.total, filtro.total + 1], function(tx, rs) {
                    var hinos = {resultados:[],hasProxima:rs.rows.length > filtro.total};

                    for (var i=0;i<rs.rows.length && i<filtro.total;i++){
                        var item = rs.rows.item(i);
                        hinos.resultados.push({
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
                tx.executeSql('SELECT id, numero, nome, assunto, texto, autor, filename FROM hino where id = ?', [Number(hino)], function(tx, rs) {
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

    }]);
