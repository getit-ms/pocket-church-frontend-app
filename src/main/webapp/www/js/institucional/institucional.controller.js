calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('institucional', {
        parent: 'site',
        url: '/institucional',
        views:{
            'content@':{
                templateUrl: 'js/institucional/institucional.form.html',
                controller: function(institucionalService, $scope, cacheService, $window){
                    function carrega(callback){
                        institucionalService.carrega(function(institucional){
                            callback(institucional);
                        });
                    };

                    cacheService.get('institucional', function(institucional){
                        $scope.institucional = institucional;
                    }, carrega);
                    
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
                }
            }
        }
    });         
}]);
        