calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('cantico', {
            parent: 'site',
            url: '/cantico',
            views:{
                'content@':{
                    templateUrl: 'js/cantico/cantico.list.html',
                    controller: function(cifraService, $scope, $state, $ionicFilterBar, $ionicFilterBarConfig, $ionicScrollDelegate, $filter, $ionicConfig){
                        $scope.filtro = {tipo:'CANTICO',total: 10};

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

                        $scope.detalhar = function(cantico){
                            $state.go('cantico.view', {id: cantico.id});
                        };
                    }
                }
            }
        }).state('cantico.view', {
            parent: 'cantico',
            url: '/:id',
            views:{
                'content@':{
                    templateUrl: 'js/cantico/cantico.form.html',
                    controller: function(cifraService, $scope, cifraService, pdfService, $stateParams,
                                         $ionicScrollDelegate, $ionicSlideBoxDelegate, shareService, config, $filter, loadingService){
                        $scope.totalPaginas = 0;

                        loadingService.show();
                        pdfService.get({
                            chave:'cantico',
                            id:$stateParams.id,
                            errorState:'cantico',
                            callback:function(cantico){
                                $scope.cantico = cantico;
                                $scope.totalPaginas = cantico.paginas.length;
                                loadingService.hide();
                            },
                            supplier:function(id, callback){
                                cifraService.carrega(id, callback);
                            }
                        });

                        $scope.slide = {activeSlide:null};

                        $scope.share = function(){
                            loadingService.show();

                            shareService.share({
                              subject:$scope.cantico.titulo,
                              file:config.server + '/rest/arquivo/download/' +
                                        $scope.cantico.cantico.id + '/' +
                                        $scope.cantico.cantico.filename + '?Dispositivo=' +
                                        config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                              success: loadingService.hide,
                              error: loadingService.hide
                            });
                        };

                        $scope.updateSlideStatus = function(index) {
                            var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
                            if (zoomFactor == 1) {
                                $ionicSlideBoxDelegate.enableSlide(true);
                            } else {
                                $ionicSlideBoxDelegate.enableSlide(false);
                            }
                        };
                    }
                }
            }
        });
    }]);
