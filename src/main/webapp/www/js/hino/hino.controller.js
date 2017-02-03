calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('hino', {
        parent: 'site',
        url: '/hino',
        views:{
            'content@':{
                templateUrl: 'js/hino/hino.list.html',
                controller: function(hinoService, $scope, $ionicFilterBar, $filter,
                            $ionicFilterBarConfig, $ionicConfig, sincronizacaoHino){
                    $scope.sincronizacao = sincronizacaoHino;

                    $scope.filtra = function(){
                        hinoService.busca().then(function(hinos){
                            $scope.hinos = hinos;
                        });
                    };

                    $scope.showSearch = function(){
                        $ionicFilterBar.show({
                            items: $scope.hinos,
                            update: function(hinos){
                                $scope.hinos = hinos;
                            },
                            cancel: function(hinos){
                                $scope.hinos = hinos;
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
                    
                    $scope.sincronizar = function(){
                        if (!$scope.sincronizacao.executando){
                            hinoService.sincroniza();
                            registraWatcher();
                        }
                    };

                    $scope.$on('$ionicView.enter', function(){
                        if ($scope.sincronizacao.executando){
                            registraWatcher();
                        }
                    });
                    
                    function registraWatcher(){
                        var stop = $scope.$watch('sincronizacao.porcentagem', function(){
                            $scope.filtra();
                            if (!$scope.sincronizacao.executando){
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
