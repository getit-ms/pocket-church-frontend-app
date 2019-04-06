calvinApp.service('leituraDAO', ['database', '$q', function(database, $q){
  function toPersitedDate(data) {
    return data.getFullYear()*10000 + data.getMonth()*100 + data.getDate();
  }

  function fromPersistedDate(data) {
    return new Date(Math.floor(data/10000), Math.floor((data%10000)/100), Math.floor(data%100));
  }

  function decrementDay(date, day) {
    date.setDate(date.getDate() - day);
    return date;
  }
        this.findUltimaAlteracao  = function(callback){
          try {
            database.db.transaction(function (tx) {
              tx.executeSql('SELECT max(ultima_atualizacao) AS ultimaAtualizacao FROM leitura_biblica2 WHERE remoto = ?', [true], function (tx, rs) {
                if (rs.rows && rs.rows.length) {
                  callback(new Date(rs.rows.item(0).ultimaAtualizacao));
                } else {
                  callback();
                }
              }, function (tx, error) {
                console.log(error);

                callback();
              });
            });
          } catch (e){
            console.log(e);

            callback();
          }
        };

        this.mergePlano = function(plano){
            var deferred = $q.defer();

            this.findPlano().then(function(salvo){
              try {
                database.db.transaction(function(tx) {
                  if (salvo && salvo.id === plano.id) {
                    tx.executeSql('UPDATE plano_leitura SET descricao = ?', [plano.descricao]);
                  } else {
                    tx.executeSql('DELETE FROM plano_leitura', []);
                    tx.executeSql('DELETE FROM leitura_biblica2', []);

                    tx.executeSql('INSERT INTO plano_leitura(id, descricao) VALUES(?,?)', [plano.id, plano.descricao]);
                  }
                  deferred.resolve();
                });
              } catch (e) {
                console.log(e);

                deferred.reject(e);
              }
            }, deferred.reject);

            return deferred.promise;
        };

        this.mergeLeitura = function(leitura){
          try {
            database.db.transaction(function (tx) {
              var atualiza = function () {
                tx.executeSql('DELETE FROM leitura_biblica2 WHERE id = ?', [leitura.dia.id]);

                tx.executeSql('INSERT INTO leitura_biblica2(id, descricao, data, ultima_atualizacao, lido, sincronizado, remoto) VALUES(?,?,?,?,?,?,?)',
                  [leitura.dia.id, leitura.dia.descricao, toPersitedDate(leitura.dia.data), leitura.ultimaAlteracao.getTime(), leitura.lido, true, true]);
              };

              tx.executeSql('SELECT ultima_atualizacao AS ultimaAtualizacao FROM leitura_biblica2 WHERE id = ?', [leitura.id], function (tx, rs) {
                if (!rs.rows || !rs.rows.length ||
                  leitura.ultimaAlteracao.getTime() < rs.rows.item(0).ultimaAtualizacao) {
                  atualiza();
                }
              }, function (tx, error) {
                atualiza();
              });
            });
          } catch(e) {
            console.log(e);
          }
        };

        this.findPlano = function(){
            var deferred = $q.defer();

            try {

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
            } catch (e) {
              console.log(e);

              deferred.reject(e);
            }

            return deferred.promise;
        };

        this.findNaoSincronizados = function(){
            var deferred = $q.defer();

            try {
              database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, lido FROM leitura_biblica2 where sincronizado = ?', [false], function(tx, rs) {
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
            } catch (e) {
              console.log(e);

              deferred.reject(e);
            }

            return deferred.promise;
        };

        this.findRangeDatas = function(){
            var deferred = $q.defer();

            try {
              database.db.transaction(function(tx) {
                tx.executeSql('SELECT min(data) as dataInicio, max(data) as dataTermino FROM leitura_biblica2', [], function(tx, rs) {
                  if (rs.rows && rs.rows.length){
                    var item = rs.rows.item(0);

                    deferred.resolve({
                      dataInicio:fromPersistedDate(item.dataInicio),
                      dataTermino:fromPersistedDate(item.dataTermino)
                    });
                  }else{
                    deferred.resolve(null);
                  }
                }, function(tx, error) {
                  deferred.reject(error);
                });
              });
            } catch (e) {
              console.log(e);

              deferred.reject(e);
            }

            return deferred.promise;
        };

        this.findByData = function(data){
            var deferred = $q.defer();

            try {
              database.db.transaction(function(tx) {
                tx.executeSql('SELECT id, descricao, lido, data FROM leitura_biblica2 where data = ?', [toPersitedDate(data)], function(tx, rs) {
                  if (rs.rows && rs.rows.length){
                    var item = rs.rows.item(0);

                    deferred.resolve({
                      dia:{
                        id:item.id,
                        descricao:item.descricao,
                        data:fromPersistedDate(item.data)
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
            } catch (e) {
              console.log(e);

              deferred.reject(e);
            }

            return deferred.promise;
        };

        this.findDatasLidas = function(){
            var deferred = $q.defer();

            try {
              database.db.transaction(function(tx) {
                tx.executeSql('SELECT data FROM leitura_biblica2 where lido = ? order by data', [true], function(tx, rs) {
                  var datas = [];

                  if (rs.rows && rs.rows.length){
                    for (var i=0;i<rs.rows.length;i++){
                      datas.push(
                        fromPersistedDate(rs.rows.item(i).data)
                      );
                    }
                  }

                  deferred.resolve(datas);
                }, function(tx, error) {
                  deferred.reject(error);
                });
              });
            } catch (e) {
              console.log(e);

              deferred.reject(e);
            }

            return deferred.promise;
        };

        this.findPorcentagem = function(){
            var deferred = $q.defer();

            try {
              database.db.transaction(function(tx) {
                var progresso = {};

                tx.executeSql('SELECT count(*) as count FROM leitura_biblica2 where descricao is not null', [], function(tx, rs) {
                  if (rs.rows && rs.rows.length){
                    var totalGeral = rs.rows.item(0).count;
                    tx.executeSql('SELECT count(*) as count FROM leitura_biblica2 where lido = ? and descricao is not null', [true], function(tx, rs) {
                      if (rs.rows && rs.rows.length){
                        progresso.porcentagem = Math.ceil((rs.rows.item(0).count / totalGeral) * 100);
                        progresso.concluido = progresso.porcentagem === 100;

                        tx.executeSql('SELECT count(*) as count FROM leitura_biblica2 where data < ? and descricao is not null', [toPersitedDate(new Date())], function(tx, rs) {
                          if (rs.rows && rs.rows.length){
                            var totalAtual = rs.rows.item(0).count;
                            tx.executeSql('SELECT count(*) as count FROM leitura_biblica2 where lido = ? and data < ? and descricao is not null', [true, toPersitedDate(decrementDay(new Date(), 1))], function(tx, rs) {
                              if (rs.rows && rs.rows.length){
                                progresso.emDia = (totalAtual - rs.rows.item(0).count) <= 1;
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
            } catch (e) {
              console.log(e);

              deferred.reject(e);
            }

            return deferred.promise;
        };

        this.atualizaLeitura = function(id, lido, callback){
          try {
            database.db.transaction(function(tx) {
              tx.executeSql('update leitura_biblica2 set lido = ?, remoto = ? where id = ?', [lido, false, id], callback);
            });
          } catch (e) {
            console.log(e);
          }
        };

        this.atualizaSincronizacao = function(id, sincronizado){
          try {
            database.db.transaction(function(tx) {
              tx.executeSql('update leitura_biblica2 set sincronizado = ?, ultima_atualizacao = ? where id = ?', [sincronizado, new Date().getTime(), id]);
            });
          } catch (e) {
            console.log(e);
          }
        };

    }]);
