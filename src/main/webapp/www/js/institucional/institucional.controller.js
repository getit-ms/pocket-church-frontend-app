calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('institucional', {
        parent: 'site',
        url: '/institucional',
        views:{
            'content@':{
                templateUrl: 'js/institucional/institucional.form.html',
                controller: function(institucionalService, $scope, cacheService, $window){
                    $scope.institucional = cacheService.load().institucional;
                    
                    $scope.carrega = function(){
                        institucionalService.carrega(function(institucional){
                            $scope.institucional = institucional;
                            cacheService.save({institucional:institucional});
                        });
                    };
                    
                    $scope.mailto = function(email){
                        $window.open('mailto:' + email, '_system');
                    };
                    
                    $scope.tel = function(tel){
                        $window.open('tel:' + tel, '_system');
                    };
                    
                    $scope.site = function(site){
                        if (site.indexOf('http://') < 0){
                            site = 'http://' + site;
                        }
                        $window.open(site, '_system');
                    };

                    $scope.carrega();
                }
            }
        }
    });         
}]);
        