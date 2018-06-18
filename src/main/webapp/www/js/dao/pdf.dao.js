calvinApp.service('pdfDAO', ['database', '$q', function(database, $q){
  this.get = function(tipo, id, pagina){
    var deferred = $q.defer();

    database.db.transaction(function(tx) {
      tx.executeSql('SELECT hash, scale FROM cache_pdf where tipo = ? and id = ? and pagina = ?', [tipo, id, pagina], function(tx, rs) {
        if (rs.rows.length) {
          var item = rs.rows.item(0);
          deferred.resolve({
            hash: item.hash,
            scale: item.scale
          });
        } else {
          deferred.resolve(undefined);
        }
      }, function(tx, error) {
        deferred.reject(error);
      });
    });

    return deferred.promise;
  };

  this.registraUso = function(tipo, id, pagina, scale){
    var deferred = $q.defer();

    database.db.transaction(function(tx) {
      tx.executeSql('UPDATE cache_pdf set scale = ?, ultimo_acesso = ? where tipo = ? and id = ? and pagina = ?', [scale, new Date().getTime(), tipo, id, pagina], function(tx, rs) {
        deferred.resolve();
      }, function(tx, error) {
        deferred.reject(error);
      });
    });

    return deferred.promise;
  };

  this.cadastra = function(tipo, id, pagina, scale){
    var deferred = $q.defer();

    var hash = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });

    database.db.transaction(function(tx) {
      tx.executeSql('INSERT into cache_pdf(tipo, id, pagina, hash, scale, ultimo_acesso) VALUES (?, ?, ?, ?, ?, ?)', [tipo, id, pagina, hash, scale, new Date().getTime()], function(tx, rs) {
        deferred.resolve({
          hash: hash,
          scale: scale
        });
      }, function(tx, error) {
        deferred.reject(error);
      });
    });

    return deferred.promise;
  };

  var LIMITE = 1000 * 60 * 60 * 24 * 5;

  this.recuperaAntigos = function(){
    var deferred = $q.defer();

    database.db.transaction(function(tx) {
      tx.executeSql('SELECT tipo, id, pagina FROM cache_pdf WHERE ultimo_acesso <= ?', [new Date().getTime() - LIMITE], function(tx, rs) {
        var itens = [];

        for (var i=0;i<rs.rows.length;i++) {
          var item = rs.rows.item(i);
          itens.push({
            tipo: item.tipo,
            id: item.id,
            pagina: item.pagina,
            hash: item.hash
          });
        }

        deferred.resolve(itens);
      }, function(tx, error) {
        deferred.reject(error);
      });
    });

    return deferred.promise;
  };


  this.remove = function(tipo, id, pagina){
    var deferred = $q.defer();

    database.db.transaction(function(tx) {
      tx.executeSql('DELETE FROM cache_pdf WHERE tipo = ? and id = ? and pagina = ?', [tipo, id, pagina], function(tx, rs) {
        deferred.resolve();
      }, function(tx, error) {
        deferred.reject(error);
      });
    });

    return deferred.promise;
  };


}]);