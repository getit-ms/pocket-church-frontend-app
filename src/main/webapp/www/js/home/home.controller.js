calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('home', {
        parent: 'site',
        url: '/home',
        views:{
            'content@':{
                templateUrl: 'js/home/home.form.html',
                controller: function($scope, configService, $httpParamSerializer, cacheService, institucionalService, $window, arquivoService){
                    var config = configService.load();
                    $scope.server = config.server;
                    $scope.headers = $httpParamSerializer(config.headers);
                    
                    function carrega(callback){
                        institucionalService.carrega(function(institucional){
                            callback(institucional);
                        });
                    };

                    cacheService.get('institucional', function(institucional){
                        $scope.institucional = institucional;
                        
                        if ($scope.institucional.divulgacao){
                            arquivoService.get($scope.institucional.divulgacao.id, function(arquivo){
                                $scope.institucional.divulgacao.localPath = arquivo.file;
                            });
                        }
                    }, carrega);
                    
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
        