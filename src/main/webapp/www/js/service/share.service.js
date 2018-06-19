calvinApp.service('shareService', ['$cordovaSocialSharing', '$cordovaFile', function($cordovaSocialSharing, $cordovaFile){
        this.share = function(notificacao){
            $cordovaSocialSharing.share(notificacao.message, notificacao.subject,
                    notificacao.file, notificacao.link).then(notificacao.success, notificacao.error);
        };

        this.shareArquivo = function(notificacao) {
          var path = 'arquivos/' + notificacao.id + '.bin';

          $cordovaFile.readAsDataURL(cordova.file.dataDirectory, path).then(function(success){
            $cordovaSocialSharing.share(null, notificacao.nome, [success], undefined).then(
              notificacao.success,
              notificacao.error);
          }, notificacao.error);
        };
}]);
