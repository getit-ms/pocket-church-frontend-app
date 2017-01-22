calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('hino', {
        parent: 'site',
        url: '/hino',
        views:{
            'content@':{
                templateUrl: 'js/hino/hino.list.html',
                controller: function(hinoService, $state, $scope, $ionicFilterBar, $filter, $ionicScrollDelegate, $ionicFilterBarConfig, $ionicConfig){
                    $scope.filtro = {total:50};
                    
                    $scope.searcher = function(page, callback){
                        hinoService.busca(angular.extend({pagina:page}, $scope.filtro), callback);
                    };

                    $scope.detalhar = function(hino){
                        $state.go('hino.view', {id: hino.id});
                    };
                    
                    $scope.showSearch = function(){
                        $ionicFilterBar.show({
                            items:[{}],
                            update: function(filter){
                                
                            },
                            expression: function(filterText){
                                if (filterText != $scope.filtro.filtro){
                                    $ionicScrollDelegate.scrollTop();
                                    $scope.filtro.filtro = filterText;
                                    $scope.filtra();
                                }
                            },
                            cancel: function(){
                                $scope.filtro.filtro = '';
                                $scope.filtra();
                            },
                            cancelText: $filter('translate')('global.cancelar'),
                            config:{
                                theme: $ionicFilterBarConfig.theme(),
                                transition: $ionicFilterBarConfig.transition(),
                                back: $ionicConfig.backButton.icon(),
                                clear: $ionicFilterBarConfig.clear(),
                                favorite: $ionicFilterBarConfig.favorite(),
                                search: $ionicFilterBarConfig.search(),
                                backdrop: $ionicFilterBarConfig.backdrop(),
                                placeholder: $filter('translate')('global.buscar'),
                                close: $ionicFilterBarConfig.close(),
                                done: $ionicFilterBarConfig.done(),
                                reorder: $ionicFilterBarConfig.reorder(),
                                remove: $ionicFilterBarConfig.remove(),
                                add: $ionicFilterBarConfig.add()
                            }
                        });
                    };
                    
                    $scope.filtra = function(){
                        $scope.$broadcast('pagination.search');
                    };
                }
            }
        }
    }).state('hino.view', {
        parent: 'hino',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/hino/hino.form.html',
                controller: function($scope, hino, shareService){
                    $scope.hino = hino;
                    
                    $scope.share = function(){
                        shareService.share({
                            subject:$scope.hino.nome,
                            message:$scope.hino.texto.replace(/<br.?>/, '\n').replace(/<.+>/, '')
                        });
                    };
                },
                resolve: {
                    hino: ['hinoService', '$stateParams', function(hinoService, $stateParams){
                        return hinoService.carrega($stateParams.id);
                    }]
                }
            }
        }
    });         
}]);
        