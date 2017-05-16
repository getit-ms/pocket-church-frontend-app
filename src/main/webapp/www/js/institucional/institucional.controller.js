calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('institucional', {
            parent: 'site',
            url: '/institucional',
            views:{
                'content@':{
                    templateUrl: 'js/institucional/institucional.form.html',
                    controller: function(institucionalService, linkService, $scope, cacheService){
                        angular.extend($scope, linkService);
                        
                        $scope.$on('$ionicView.enter', function(){
                            cacheService.get({
                                chave:'institucional',
                                callback:function(institucional){
                                    $scope.institucional = institucional;

                                    if (!$scope.institucional.enderecos){
                                        $scope.institucional.enderecos = [];

                                        if ($scope.institucional.endereco){
                                            $scope.institucional.enderecos.push($scope.institucional.endereco);
                                        }
                                    }

                                    $scope.institucional.endereco = undefined;
                                }, 
                                supplier:function(callback){
                                    institucionalService.carrega(function(institucional){
                                        callback(institucional);
                                    });
                                }
                            });
                        });
                    }
                }
            }
        });         
    }]);
