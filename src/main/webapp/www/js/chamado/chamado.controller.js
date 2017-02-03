calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('chamado', {
            parent: 'site',
            url: '/chamado',
            views:{
                'content@':{
                    templateUrl: 'js/chamado/chamado.list.html',
                    controller: function(chamadoService, $filter, $scope, message, loadingService){
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

                            loadingService.show();
                            
                            chamadoService.cadastra($scope.chamado, function(){
                                $scope.clear();
                                loadingService.hide();
                                message({title:'global.title.200',template:'mensagens.MSG-001'});
                            }, function(){
                                loadingService.hide();
                            });
                        };

                        $scope.clear();
                    }
                }
            }
        });
    }]);
