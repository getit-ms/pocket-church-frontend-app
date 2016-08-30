calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('institucional', {
        parent: 'site',
        url: '/institucional',
        views:{
            'content@':{
                templateUrl: 'js/institucional/institucional.form.html',
                controller: function(institucionalService, linkService, $scope, cacheService){
                    angular.extend($scope, linkService);
                    
                    cacheService.get({
                        chave:'institucional',
                        callback:function(institucional){
                            $scope.institucional = institucional;
                        }, 
                        supplier:function(callback){
                            institucionalService.carrega(function(institucional){
                                callback(institucional);
                            });
                        }
                    });
                }
            }
        }
    });         
}]);
        