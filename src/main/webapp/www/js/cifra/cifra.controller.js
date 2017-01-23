calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('cifra', {
            parent: 'site',
            url: '/cifra',
            views:{
                'content@':{
                    templateUrl: 'js/cifra/cifra.list.html',
                    controller: function(cifraService, $scope, $state, $ionicFilterBar, $ionicFilterBarConfig, $ionicScrollDelegate, $filter, $ionicConfig){
                        $scope.filtro = {total: 10};

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
                    controller: function(cifraService, $scope, cifraService, pdfService, $stateParams, 
                                         $ionicScrollDelegate, $ionicSlideBoxDelegate, shareService, config, $filter, $ionicLoading){
                        $scope.totalPaginas = 0;
                        
                        pdfService.get({
                            chave:'cifra',
                            id:$stateParams.id,
                            errorState:'cifra',
                            callback:function(cifra){
                                $scope.cifra = cifra;
                                $scope.totalPaginas = cifra.paginas.length;
                            },
                            supplier:function(id, callback){
                                cifraService.carrega(id, callback);
                            }
                        });
                        
                        $scope.slide = {activeSlide:null};
                        
                        $scope.share = function(){
                            $ionicLoading.show({template:'<ion-spinner icon="spiral" class="spinner spinner-spiral"></ion-spinner> ' + $filter('translate')('global.carregando')});
                            
                            shareService.share({subject:$scope.cifra.titulo,file:config.server + '/rest/arquivo/download/' + 
                                        $scope.cifra.cifra.id + '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja});
                            
                            $ionicLoading.hide();
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
