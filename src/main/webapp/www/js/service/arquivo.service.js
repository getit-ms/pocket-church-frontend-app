calvinApp.service('arquivoService', ['$cordovaFileTransfer', '$cordovaFile', 'config', '$window', '$cordovaNetwork', '$q',
    function($cordovaFileTransfer, $cordovaFile, config, $window, $cordovaNetwork, $q){
        this.timeout = 1000 * 60 * 60 * 24 * 5;

        this.init = function(){
            var deferred = $q.defer();
            
            try{
                $cordovaFile.checkDir(cordova.file.dataDirectory, "arquivos").then(function(){
                    
                }, function(){
                    $cordovaFile.createDir(cordova.file.dataDirectory, "arquivos");
                });

                $cordovaFile.removeRecursively(cordova.file.cacheDirectory, 'tmp').then(function(){
                    $cordovaFile.createDir(cordova.file.cacheDirectory, "tmp");
                    deferred.resolve();
                }, function(){
                    deferred.resolve();
                });
            }catch(e){
                console.log(e);
                deferred.reject();
            }
            
            return deferred.promise;
        };

        this.get = function(id, callback){
            if (!id || !callback) console.error("arquivoService.get: id and callback are required");

            var cache = load(id);
            if (cache && cache.uuid == config.headers.Dispositivo){
                cache.access = new Date().getTime();
                save(id, cache);
                callback({success:true, file:cordova.file.dataDirectory + cache.file});
            }else{
                callback({loading:true, file:'img/loading.gif'});
                download(id, callback);
            }
        };

        this.clean = function(i){
            var deferred = $q.defer();
            
            try{
                var self = this;
                i = angular.isUndefined(i) ? 0 : i;
                while (i < $window.localStorage.length){
                    var key = $window.localStorage.key(i);

                    if (key.startsWith('arquivo.')){
                        var cache = $window.localStorage.getItem(key);

                        if (cache){
                            cache = angular.fromJson(cache);

                            if (!cache.access || (cache.access + this.timeout) < new Date().getTime()){
                                remove(key.substring(key.indexOf('.') + 1), function(){
                                    $window.localStorage.removeItem(key);
                                    self.clean(i).then(deferred.resolve, deferred.reject);
                                });

                                return deferred.promise;
                            }
                        }

                    }

                    i++;
                }
                deferred.resolve();
            }catch(e){
                console.log(e);
                deferred.reject();
            }
            
            return deferred.promise;
        };

        function load(id){
            return angular.fromJson($window.localStorage.getItem('arquivo.'+id));
        }

        function save(id, cache){
            $window.localStorage.setItem('arquivo.' + id, angular.toJson(cache));
        }

        function remove(id, callback){
            $cordovaFile.removeFile(cordova.file.dataDirectory, 'arquivos/' + id + '.bin').then(function(){
                $window.localStorage.removeItem('arquivo.' + id);
                if (callback){
                    callback();
                }
            });
        }

        function download(id, callback){
            var path = 'arquivos/' + id + '.bin';
            var temp = 'tmp/' + new Date().getTime() + '.' + id + '.bin';
            var url = config.server + '/rest/arquivo/download/' + id + '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja;

            try{
                if ($cordovaNetwork.isOnline()){
                    $cordovaFileTransfer.download(url, cordova.file.cacheDirectory + temp).then(function(success){
                        $cordovaFile.moveFile(cordova.file.cacheDirectory, temp, cordova.file.dataDirectory, path).then(function(){
                            save(id, {file:path,access:new Date().getTime(),uuid:config.headers.Dispositivo});
                            callback({success:true, file:cordova.file.dataDirectory + path});
                        }, function(error){
                            callback({error:true, file:'img/fail.png'});
                            console.error(error);
                        });
                    }, function(error){
                        callback({error:true, file:'img/fail.png'});
                        remove(id);
                        console.error(error);
                    });
                }else{
                    callback({error:true, file:'img/fail.png'});
                    remove(id);
                }
            }catch(e){
                callback({error:true, file:'img/fail.png'});
                remove(id);
                console.error(e);
            }
        }
    }]);
