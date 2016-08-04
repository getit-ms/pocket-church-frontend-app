calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('preferencias', {
        parent: 'site',
        url: '/preferencias',
        views:{
            'content@':{
                templateUrl: 'js/preferencias/preferencias.form.html',
                controller: function($scope, message, acessoService, $rootScope, $state){
                    acessoService.buscaPreferencias(function(preferencias){
                        $scope.preferencias = preferencias;
                        $scope.ministeriosSelecionados = [];
                        if ($scope.preferencias.ministeriosInteresse){
                            for (var i=0;i<$scope.preferencias.ministeriosInteresse.length;i++){
                                var min = $scope.preferencias.ministeriosInteresse[i];
                                $scope.ministeriosSelecionados[min.id] = true;
                            }
                        }
                    });
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
                            $state.reload();
                        });
                    };
                    
                    $scope.logout = function(){
                        acessoService.logout(function(){
                            $rootScope.usuario = null;
                            $rootScope.funcionalidades = null;
                            $state.go('site');
                        });
                    };
                }
            }
        }
    });         
}]);
        