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

                    $scope.institucional = cacheService.load().institucional;
                    
                    $scope.carrega = function(){
                        institucionalService.carrega(function(institucional){
                            $scope.institucional = institucional;
                            cacheService.save({institucional:institucional});
                            
                            if ($scope.institucional.divulgacao){
                                $scope.institucional.divulgacao.localPath = 'img/loading.gif';
                                arquivoService.exists($scope.institucional.divulgacao.id, function(exists){
                                    if (exists){
                                        $scope.institucional.divulgacao.localPath = 
                                                cordova.file.cacheDirectory + 'arquivos/' + $scope.institucional.divulgacao.id + '.bin';
                                    }else{
                                        arquivoService.download($scope.institucional.divulgacao.id, function(){
                                            $scope.institucional.divulgacao.localPath = 
                                                    cordova.file.cacheDirectory + 'arquivos/' + $scope.institucional.divulgacao.id + '.bin';
                                        }, cordova.file.cacheDirectory);
                                    }
                                }, cordova.file.cacheDirectory);
                            }
                        });
                    };
                    
                    $scope.open = function(link){
                        if (!link) return;
                        if (link.indexOf('http://') < 0 &&
                                link.indexOf('https://') < 0){
                            link = 'http://' + link;
                        }
                        $window.open(link, '_system');
                    };

                    $scope.carrega();
                }
            }
        }
    });         
}]);
        