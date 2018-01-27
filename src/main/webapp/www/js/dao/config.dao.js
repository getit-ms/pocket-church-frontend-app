calvinApp.service('configDAO', ['database', '$q', function(database, $q){
        this.get  = function(callback){
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
        };

        this.set = function(config){
            database.db.transaction(function(tx) {
                tx.executeSql('delete from config');

                tx.executeSql('insert into config(value) values(?)',
                [angular.toJson(config)]);

            }, function(tx, error) {
                console.log(error);
            });
        };

    }]);
