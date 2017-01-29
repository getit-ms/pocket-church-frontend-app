calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('preferencias', {
            parent: 'site',
            url: '/preferencias',
            views:{
                'content@':{
                    templateUrl: 'js/preferencias/preferencias.form.html',
                    controller: function($scope, message, acessoService, $rootScope, $state, $ionicViewService){
                        $scope.$on('$ionicView.enter', function(){
                            acessoService.buscaPreferencias(function(preferencias){
                                $scope.preferencias = preferencias;
                                
                                $scope.ministeriosSelecionados = [];
                                if ($scope.preferencias.ministeriosInteresse){
                                    for (var i=0;i<$scope.preferencias.ministeriosInteresse.length;i++){
                                        var min = $scope.preferencias.ministeriosInteresse[i];
                                        $scope.ministeriosSelecionados[min.id] = true;
                                    }
                                }
                                $scope.verifyTodosMinisterios();
                            });
                        });
                        
                        $scope.toggleTodosMinisterios = function(){
                            if ($scope.ministerios){
                                if ($scope.todosMinisterios){
                                    $scope.ministeriosSelecionados = [];
                                    $scope.todosMinisterios = false;
                                }else{
                                    $scope.ministerios.forEach(function(min){
                                        $scope.ministeriosSelecionados[min.id] = true;
                                    });
                                    $scope.todosMinisterios = true;
                                }
                            }
                        };
                        
                        $scope.verifyTodosMinisterios = function(){
                            if ($scope.ministerios){
                                $scope.todosMinisterios = true;
                                for (var i=0;i<$scope.ministerios.length;i++){
                                    var min = $scope.ministerios[i];
                                    if (!$scope.ministeriosSelecionados[min.id]){
                                        $scope.todosMinisterios = false;
                                        break;
                                    }
                                };
                            }
                        };
                        
                        $scope.ministerios = acessoService.buscaMinisterios();
                        $scope.horasVersiculoDiario = acessoService.buscaHorasVersiculoDiario();
                        
                        $scope.salvar = function(form){
                            if (form.$invalid){
                                message({title:'global.title.400',template:'mensagens.MSG-002'})
                                return;
                            }
                            
                            $scope.preferencias.ministeriosInteresse = [];
                            for (var i=0;i<$scope.ministerios.length;i++){
                                var min = $scope.ministerios[i];
                                if ($scope.ministeriosSelecionados[min.id]){
                                    $scope.preferencias.ministeriosInteresse.push(min);
                                }
                            }
                            
                            acessoService.salvaPreferencias($scope.preferencias, function(){
                                message({title: 'global.title.200',template: 'mensagens.MSG-001'});
                            });
                        };
                        
                        $scope.logout = function(){
                            acessoService.logout(function(){
                                $rootScope.usuario = null;
                                $rootScope.funcionalidades = null;
                                $ionicViewService.nextViewOptions({
                                    historyRoot: true,
                                    disableBack: true
                                });
                                $state.go('site');
                            });
                        };
                    }
                }
            }
        });         
    }]);
