calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('oracao', {
        parent: 'site',
        url: '/oracao',
        views:{
            'content@':{
                templateUrl: 'js/oracao/oracao.form.html',
                controller: function(oracaoService, $scope, loadingService){
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
                        loadingService.show();

                        oracaoService.submete($scope.pedido, function(pedido){
                            $scope.clear();
                            loadingService.hide();
                            $scope.$broadcast('pagination.refresh');
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
        