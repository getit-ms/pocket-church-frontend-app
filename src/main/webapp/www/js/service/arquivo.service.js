calvinApp.service('arquivoService', ['$cordovaFileTransfer', '$cordovaFile', 'config', 
    function($cordovaFileTransfer, $cordovaFile, config){
        this.download = function(id, callback, dir){
            var path = this.localPath(id);
            var url = this.remoteURL(id);
            
            $cordovaFile.checkDir(dir, "arquivos").then(function(){}, function(){
                $cordovaFile.createDir(dir, "arquivos");
            });
            
			if (!dir) dir = cordova.file.dataDirectory;
			
            var retorno = {
                path: path,
                progresso: 0,
                success: false,
                error: false
            };
            
            $cordovaFileTransfer.download(url, dir + path).then(function(success){
                retorno.success = true;
                if (callback) callback(id, true);
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
        
        this.remove = function(id, dir){
			if (!dir) dir = cordova.file.dataDirectory;
            $cordovaFile.removeFile(dir, this.localPath(id)).then(callback);
        };
        
        this.exists = function(id, dir){
            var exists;
			
			if (!dir) dir = cordova.file.dataDirectory;
			
            $cordovaFile.checkFile(dir, this.localPath(id)).then(function(){
                this.exists = true;
            });
            return exists;
        };
}]);
        