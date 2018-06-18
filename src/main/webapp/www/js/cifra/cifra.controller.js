calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('cifra', {
            parent: 'site',
            url: '/cifra',
            views:{
                'content@':{
                    templateUrl: 'js/cifra/cifra.list.html',
                    controller: function(cifraService, $scope, $state, $ionicFilterBar, $ionicFilterBarConfig, $ionicScrollDelegate, $filter, $ionicConfig){
                        $scope.filtro = {tipo:'CIFRA',total: 10};

                        $scope.searcher = function(page, callback){
                            cifraService.busca(angular.extend({pagina: page}, $scope.filtro), callback);
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

                        $scope.detalhar = function(cifra){
                            $state.go('cifra.view', {id: cifra.id});
                        };
                    }
                }
            }
        }).state('cifra.view', {
            parent: 'cifra',
            url: '/:id',
            views:{
                'content@':{
                    templateUrl: 'js/cifra/cifra.form.html',
                    controller: function(cifraService, $scope, pdfService, $stateParams,shareService, config, $filter, loadingService){
                        $scope.status = {};

                        cifraService.carrega($stateParams.id, function(cifra) {
                          $scope.cifra = cifra;
                        });

                      $scope.share = function(){
                        loadingService.show();

                        arquivoService.get($scope.cifra.cifra.id, function(file) {
                          shareService.share({
                            subject:$scope.cifra.titulo,
                            file: 'file://' + file.file,
                            success: loadingService.hide,
                            error: loadingService.hide
                          });
                        }, function(){}, loadingService.hide);
                      };

                    }
                }
            }
        });
    }]);
