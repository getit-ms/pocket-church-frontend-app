calvinApp.service('shareService', ['$cordovaSocialSharing', '$cordovaFile', function($cordovaSocialSharing, $cordovaFile){
        this.share = function(notificacao){
            $cordovaSocialSharing.share(notificacao.message, notificacao.subject,
                    notificacao.file, notificacao.link).then(notificacao.success, notificacao.error);
        };

        this.shareArquivo = function(notificacao) {
          var path = 'arquivos/' + notificacao.arquivo.id + '.bin';

          $cordovaFile.readAsDataURL(cordova.file.dataDirectory, path).then(function(success){
            $cordovaSocialSharing.share(null, notificacao.arquivo.filename, success.replace(/data:[a-z]+\/[a-z]+;base64,/, 'data:image/' + (notificacao.mimeType || 'application/pdf' ) + ';base64,'), undefined).then(
              notificacao.success,
              notificacao.error);
          }, notificacao.error);
        };
}]);
