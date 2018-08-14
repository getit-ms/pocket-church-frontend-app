calvinApp.service('arquivoService', ['Restangular', '$cordovaFileTransfer', '$cordovaFile', 'config', '$window', '$cordovaNetwork', '$q',
    function(Restangular, $cordovaFileTransfer, $cordovaFile, config, $window, $cordovaNetwork, $q){
        this.timeout = 1000 * 60 * 60 * 24 * 5;

        this.api = function(){
          return Restangular.all('arquivo');
        };

        this.init = function(){
            var deferred = $q.defer();

            try{
                $cordovaFile.checkDir(cordova.file.dataDirectory, "arquivos").then(function(){}, function(){
                    $cordovaFile.createDir(cordova.file.dataDirectory, "arquivos");
                });

                $cordovaFile.removeRecursively(cordova.file.cacheDirectory, 'tmp').then(function(){
                    $cordovaFile.createDir(cordova.file.cacheDirectory, "tmp");
                    deferred.resolve();
                }, function(){
                    deferred.reject();
                });
            }catch(e){
                console.log(e);
                deferred.reject();
            }

            return deferred.promise;
        };

        this.upload = function(arquivo, success, error) {
          this.api().one('upload/base64').customPOST(arquivo).then(success, error);
        };

        this.get = function(id, callback, tempCallback, errorCallback, progressCallback){
            if (!id || !callback) console.error("arquivoService.get: id and callback are required");

            var cache = load(id);
            if (cache && cache.uuid === config.headers.Dispositivo){
                cache.access = new Date().getTime();
                save(id, cache);
                callback({success:true, file:parseFilename(cordova.file.dataDirectory + cache.file)});
            }else{
                if (tempCallback) {
                    tempCallback({loading:true, file:'img/loading.gif'});
                }
                download(id, callback, tempCallback, errorCallback, progressCallback);
            }
        };

        this.clean = function(i){
            var deferred = $q.defer();

            try{
                var self = this;
                i = angular.isUndefined(i) ? 0 : i;
                while (i < $window.localStorage.length){
                    var key = $window.localStorage.key(i);

                    if (key.indexOf('arquivo.') == 0){
                        var cache = $window.localStorage.getItem(key);

                        if (cache){
                            cache = angular.fromJson(cache);

                            if (!cache.access || (cache.access + this.timeout) < new Date().getTime()){
                                remove(key.substring(key.indexOf('.') + 1), function(){
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

        function parseFilename(filename) {
          return filename.replace('file://', '');
        }

        function remove(id, callback){
          try{
            $cordovaFile.removeFile(cordova.file.dataDirectory, 'arquivos/' + id + '.bin').then(function(){
              $window.localStorage.removeItem('arquivo.' + id);
              if (callback){
                callback();
              }
            });
          }catch(e){
            console.error(e);
          }
        }

        this.downloadAndSave = function(url, filename, success, error) {
          function doDownload() {
            $cordovaFileTransfer.download(url, parseFilename(cordova.file.externalRootDirectory + 'Download/' + filename))
              .then(success, error)
          }

          function createDownloads () {
            $cordovaFile.createDir(cordova.file.externalRootDirectory, 'Download')
              .then(function() {
                doDownload();
              }, function() {
                doDownload();
              });
          }

          createDownloads();
        };

        function download(id, callback, tempCallback, errorCallback, progressCallback){
            var path = 'arquivos/' + id + '.bin';
            var temp = 'tmp/' + new Date().getTime() + '.' + id + '.bin';
            var url = config.server + '/rest/arquivo/download/' + id + '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja;

            try{
                if ($cordovaNetwork.isOnline()){
                    $cordovaFileTransfer.download(url, parseFilename(cordova.file.cacheDirectory + temp)).then(function(success){
                        $cordovaFile.moveFile(cordova.file.cacheDirectory, temp, cordova.file.dataDirectory, path).then(function(){
                            save(id, {file:path,access:new Date().getTime(),uuid:config.headers.Dispositivo});
                            callback({success:true, file:parseFilename(cordova.file.dataDirectory + path)});
                        }, function(error){
                            errorCallback({error:true, file:'img/fail.png'});
                            console.error(error);
                        });
                    }, function(error){
                        errorCallback({error:true, file:'img/fail.png'});
                        remove(id);
                        console.error(error);
                    }, progressCallback);
                }else{
                    errorCallback({error:true, file:'img/fail.png'});
                    remove(id);
                }
            }catch(e){
                errorCallback({error:true, file:'img/fail.png'});
                remove(id);
                console.error(e);
            }
        }
    }]);
