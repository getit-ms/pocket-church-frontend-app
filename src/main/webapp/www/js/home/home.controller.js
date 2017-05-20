calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('home', {
            parent: 'site',
            url: '/home',
            views:{
                'content@':{
                    templateUrl: 'js/home/home.form.html',
                    controller: function($scope, cacheService, linkService, institucionalService, arquivoService){
                        angular.extend($scope, linkService);
                        
                        $scope.$on('$ionicView.enter', function(){
                            cacheService.get({
                                chave:'institucional',
                                callback:function(institucional){
                                    $scope.institucional = institucional;
                                    
                                    if ($scope.institucional.divulgacao){
                                        arquivoService.get($scope.institucional.divulgacao.id, function(arquivo){
                                            $scope.institucional.divulgacao.localPath = arquivo.file;
                                        }, function(arquivo){
                                            $scope.institucional.divulgacao.localPath = arquivo.file;
                                        }, function(arquivo){
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
                        });
                        
                    }
                }
            }
        });         
    }]);
