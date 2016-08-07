calvinApp.service('arquivoService', ['$cordovaFileTransfer', '$cordovaFile', 'config', 
    function($cordovaFileTransfer, $cordovaFile, config){
        this.init = function(){
            $cordovaFile.checkDir(cordova.file.dataDirectory, "arquivos").then(function(){}, function(){
                $cordovaFile.createDir(cordova.file.dataDirectory, "arquivos");
            });
            
            $cordovaFile.checkDir(cordova.file.cacheDirectory, "arquivos").then(function(){}, function(){
                $cordovaFile.createDir(cordova.file.cacheDirectory, "arquivos");
            });
			
			$cordovaFile.removeRecursively(cordova.file.cacheDirectory, 'tmp').then(function(){
				$cordovaFile.createDir(cordova.file.cacheDirectory, "tmp");
			});
        };
        
        this.download = function(id, callback, dir){
            var path = this.localPath(id);
            var temp = 'tmp/' + new Date().getTime() + '.' + id + '.bin';
            var url = this.remoteURL(id);
            
            if (!dir) dir = cordova.file.dataDirectory;
            
            var retorno = {
                path: path,
                progresso: 0,
                success: false,
                error: false
            };
            
            $cordovaFileTransfer.download(url, cordova.file.cacheDirectory + temp).then(function(success){
                $cordovaFile.moveFile(cordova.file.cacheDirectory, temp, dir, path).then(function(){
                    retorno.success = true;
                    if (callback) callback(id, true);
                }, function(){
                    retorno.error = true;
                    if (callback) callback(id, false);
                });
            }, function(error){
                retorno.error = true;
                if (callback) callback(id, false);
            }, function(progresso){
                retorno.progresso = progresso.loaded / progresso.total;
            });
            
            return retorno;
        };
        
        this.localPath = function(id){
            return 'arquivos/' + id + ".bin";
        };
        
        this.remoteURL = function(id){
            return config.server + '/rest/arquivo/download/' + id + '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja;
        };
        
        this.remove = function(id, callback, dir){
            if (!dir) dir = cordova.file.dataDirectory;
            $cordovaFile.removeFile(dir, this.localPath(id)).then(callback);
        };
        
        this.exists = function(id, callback, dir){
            if (!dir) dir = cordova.file.dataDirectory;
            
            $cordovaFile.checkFile(dir, this.localPath(id)).then(function(){
                if (callback) callback(true);
            }, function(){
                if (callback) callback(false);
            });
        };
    }]);
