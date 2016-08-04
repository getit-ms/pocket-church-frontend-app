calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('oracao', {
        parent: 'site',
        url: '/oracao',
        views:{
            'content@':{
                templateUrl: 'js/oracao/oracao.form.html',
                controller: function(oracaoService, $scope){
                    $scope.searcher = function(page, callback){
                        oracaoService.busca({pagina:page,total:10}, callback);
                    };

                    $scope.clear = function(){
                        $scope.pedido = {
                            nome:$scope.usuario.nome,
                            email:$scope.usuario.email
                        };
                    };

                    $scope.submeter = function(){
                        oracaoService.submete($scope.pedido, function(pedido){
                            $scope.clear();
                            $scope.$broadcast('pagination.refresh');
                        })
                    };

                    $scope.clear();
                }
            }
        }
    });         
}]);
        