calvinApp.service('shareService', ['$cordovaSocialSharing', function($cordovaSocialSharing){
        this.share = function(notificacao){
            $cordovaSocialSharing.share(notificacao.message, notificacao.subject, 
                    notificacao.file, notificacao.link).then(notificacao.success, notificacao.error);
        };
}]);
        