calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('chamado', {
            parent: 'site',
            url: '/chamado',
            views:{
                'content@':{
                    templateUrl: 'js/chamado/chamado.list.html',
                    controller: function(chamadoService, $state, $scope, message, $ionicLoading){
                        $scope.searcher = function(page, callback){
                            chamadoService.busca({pagina:page,total:10}, callback);
                        };

                        $scope.clear = function(){
                            $scope.chamado = {};
                            if ($scope.usuario){
                                $scope.chamado.nomeSolicitante = $scope.usuario.nome;
                                $scope.chamado.emailSolicitante = $scope.usuario.email;
                            }
                        };
                        
                        $scope.$on('$ionicView.enter', function(){
                            $scope.clear();
                        });

                        $scope.cadastrar = function(form){
                            if (form.$invalid){
                                message({title:'global.title.400',template:'mensagens.MSG-002'})
                                return;
                            }

                            $ionicLoading.show({template:'<ion-spinner icon="spiral" class="spinner spinner-spiral"></ion-spinner> ' + $filter('translate')('global.carregando')});
                            
                            chamadoService.cadastra($scope.chamado, function(){
                                $scope.clear();
                                $ionicLoading.hide();
                                message({title:'global.title.200',template:'mensagens.MSG-001'});
                            }, function(){
                                $ionicLoading.hide();
                            });
                        };

                        $scope.clear();
                    }
                }
            }
        });
    }]);
