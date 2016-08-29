calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('chamado', {
            parent: 'site',
            url: '/chamado',
            views:{
                'content@':{
                    templateUrl: 'js/chamado/chamado.list.html',
                    controller: function(chamadoService, $scope, $ionicViewService, $state){
                        $scope.searcher = function(page, callback){
                            chamadoService.busca({pagina:page,total:10}, callback);
                        };

                        $scope.clear = function(){
                            $scope.chamado = {};
                        };

                        $scope.cadastrar = function(form){
                            if (form.$invalid){
                                message({title:'global.title.400',template:'mensagens.MSG-002'})
                                return;
                            }

                            chamadoService.cadastra($scope.chamado, function(){
                                message({title:'global.title.200',template:'mensagens.MSG-001'});
                                $scope.clear();
                            });
                        };

                        $scope.clear();
                    }
                }
            }
        });
    }]);
