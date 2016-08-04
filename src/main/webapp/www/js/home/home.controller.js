calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('home', {
        parent: 'site',
        url: '/home',
        views:{
            'content@':{
                templateUrl: 'js/home/home.form.html',
                controller: function($scope, configService, $httpParamSerializer, cacheService, institucionalService, $window){
                    var config = configService.load();
                    $scope.server = config.server;
                    $scope.headers = $httpParamSerializer(config.headers);

                    $scope.institucional = cacheService.load().institucional;
                    
                    $scope.carrega = function(){
                        institucionalService.carrega(function(institucional){
                            $scope.institucional = institucional;
                            cacheService.save({institucional:institucional});
                        });
                    };
                    
                    $scope.open = function(link){
                        if (!link) return;
                        if (link.indexOf('http://') < 0){
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
        