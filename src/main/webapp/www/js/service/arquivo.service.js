calvinApp.service('arquivoService', ['$cordovaFileTransfer', '$cordovaFile', 'config', '$window', '$cordovaNetwork', 
    function($cordovaFileTransfer, $cordovaFile, config, $window, $cordovaNetwork){
        this.timeout = 1000 * 60 * 60 * 24 * 5;
        
        this.init = function(){
            $cordovaFile.checkDir(cordova.file.dataDirectory, "arquivos").then(function(){}, function(){
                $cordovaFile.createDir(cordova.file.dataDirectory, "arquivos");
            });
            
            $cordovaFile.removeRecursively(cordova.file.cacheDirectory, 'tmp').then(function(){
                $cordovaFile.createDir(cordova.file.cacheDirectory, "tmp");
            });
        };
        
        this.get = function(id, callback){
            if (!id || !callback) console.error("arquivoService.get: id and callback are required");
            
            var cache = load(id);
            if (cache && cache.file.startwWith(cordova.file.dataDirectory)){
                cache.access = new Date().getTime();
                save(id, cache);
                callback({success:true, file:cache.file});
            }else{
                callback({loading:true, file:'img/loading.gif'});
                download(id, callback);
            }
        };
        
        this.clean = function(){
            for (i=0;i<$window.localStorage.length;i++){
                var key = $window.localStorage.key(i);
                if (key.startsWith('arquivo.')){
                    var cache = $window.localStorage.getItem(key);

                    if (cache){
                        if (!cache.file || !cache.access ||
                                !cache.file.startwWith(cordova.file.dataDirectory)
                                || cache.access + this.timeout < new Date().getTime()){
                            remove(chave, id);
                        }
                    }
                }
            }
        };
        
        function load(id){
            return angular.fromJson($window.localStorage.getItem('arquivo.'+id));
        }
        
        function save(id, cache){
            $window.localStorage.setItem('arquivo.' + id, angular.toJson(cache));
        }
        
        function remove(id){
            $cordovaFile.remove(cordova.file.dataDirectory, 'arquivos/' + id + '.bin').then(function(){
                $window.localStorage.removeItem('arquivo.' + id);
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
                            save(id, {file:cordova.file.dataDirectory + path,access:new Date().getTime()});
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
