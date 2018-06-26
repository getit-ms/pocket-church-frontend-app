calvinApp.service('configDAO', ['database', '$q', function(database, $q){
  this.get  = function(callback){
    doGet(callback);
  };

  function doGet(callback) {
    if (!database.db) {
      setTimeout(function(){
        doGet(callback);
      }, 300);
    }

    try {
      database.db.transaction(function(tx) {
        tx.executeSql('SELECT value FROM config', [], function(tx, rs) {
          if (rs.rows && rs.rows.length){
            callback(angular.fromJson(rs.rows.item(0).value));
          }else{
            callback(undefined);
          }
        }, function(tx, error) {
          callback(undefined);
        });
      });
    } catch (ex) {
      console.log(ex);

      callback(undefined);
    }
  }

  this.set = function(config){
    return doSet(config);
  };

  function doSet(config) {
    if (!database.db) {
      setTimeout(function() {
        doSet(config);
      }, 300);
    }

    try {
      database.db.transaction(function(tx) {
        tx.executeSql('delete from config', [], function(tx, rs) {
          tx.executeSql('insert into config(value) values(?)',
            [angular.toJson(config)]);
        });
      }, function(tx, error) {
        console.log(error);
      });
    } catch (ex) {
      console.log(ex);
    }
  }

}]);
