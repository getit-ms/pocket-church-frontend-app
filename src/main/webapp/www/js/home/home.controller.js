calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('home', {
        parent: 'site',
        url: '/home',
        views:{
            'content@':{
                templateUrl: 'js/home/home.form.html',
                controller: function($scope, cacheService, institucionalService, $window, arquivoService){
                    cacheService.get({
                        chave:'institucional',
                        callback:function(institucional){
                            $scope.institucional = institucional;

                            if ($scope.institucional.divulgacao){
                                arquivoService.get($scope.institucional.divulgacao.id, function(arquivo){
                                    $scope.institucional.divulgacao.localPath = arquivo.file;
                                });
                            }
                        }, 
                        supplier:function(callback){
                            institucionalService.carrega(function(institucional){
                                callback(institucional);
                            });
                        }
                    });
                    
                    $scope.open = function(link){
                        if (!link) return;
                        if (link.indexOf('http://') < 0 &&
                                link.indexOf('https://') < 0){
                            link = 'http://' + link;
                        }
                        $window.open(link, '_system');
                    };
                }
            }
        }
    });         
}]);
        