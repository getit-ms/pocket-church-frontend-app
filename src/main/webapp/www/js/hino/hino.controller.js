calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('hino', {
        parent: 'site',
        url: '/hino',
        views:{
            'content@':{
                templateUrl: 'js/hino/hino.list.html',
                controller: function(hinoService, $scope, $ionicFilterBar, $filter, $ionicScrollDelegate,
                            $ionicFilterBarConfig, $ionicConfig, sincronizacaoHino){
                    $scope.sincronizacao = sincronizacaoHino;
                    
                    $scope.filtro = {total:50};
                    
                    $scope.searcher = function(page, callback){
                        hinoService.busca(angular.extend({pagina:page}, $scope.filtro)).then(callback);
                    };

                    $scope.showSearch = function(){
                        $ionicFilterBar.show({
                            items:[{}],
                            update: function(filter){
                                
                            },
                            expression: function(filterText){
                                if (filterText !== $scope.filtro.filtro){
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

                    $scope.$on('$ionicView.enter', function(){
                        if (!$scope.sincronizacao.executando){
                            hinoService.sincroniza();
                        }
                        registraWatcher();
                    });
                    
                    function registraWatcher(){
                        var stop = $scope.$watch('sincronizacao.porcentagem', function(){
                            if (!$scope.sincronizacao.executando){
                                $scope.$broadcast('scroll.refreshComplete');
                                $scope.filtra();
                                stop();
                            }
                        });
                    }

                    $scope.filtra();
                }
            }
        }
    }).state('hino.view', {
        parent: 'hino',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/hino/hino.form.html',
                controller: function($scope, hinoService, $stateParams, shareService, loadingService, config){
                    hinoService.carrega($stateParams.id).then(function(hino){
                        $scope.hino = hino;
                    });

                    $scope.share = function(){
                        loadingService.show();

                        shareService.share({
                            subject:$scope.hino.nome,
                            file:config.server + '/rest/hino/' + $scope.hino.id + '/pdf?Dispositivo=' +
                                config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                            success: loadingService.hide,
                            error: loadingService.hide
                        });
                    };
                }
            }
        }
    });
}]);
