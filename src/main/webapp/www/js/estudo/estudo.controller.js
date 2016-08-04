calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('estudo', {
        parent: 'site',
        url: '/estudo',
        views:{
            'content@':{
                templateUrl: 'js/estudo/estudo.list.html',
                controller: function(estudoService, $state, $scope){
                    $scope.filtro = {total:10};
                    
                    $scope.searcher = function(page, callback){
                        estudoService.busca(angular.extend({pagina:page}, $scope.filtro), callback);
                    };

                    $scope.detalhar = function(estudo){
                        $state.go('estudo.view', {id: estudo.id});
                    };
                }
            }
        }
    }).state('estudo.view', {
        parent: 'estudo',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/estudo/estudo.form.html',
                controller: function(estudo, $scope){
                    $scope.estudo = estudo;
                },
                resolve:{
                    estudo: ['estudoService', '$stateParams', function(estudoService, $stateParams){
                        return estudoService.carrega($stateParams.id);
                    }]
                }
            }
        }
    });         
}]);
        