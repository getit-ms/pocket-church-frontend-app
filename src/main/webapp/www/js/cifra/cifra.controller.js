calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('cifra', {
            parent: 'site',
            url: '/cifra',
            views:{
                'content@':{
                    templateUrl: 'js/cifra/cifra.list.html',
                    controller: function(cifraService, $scope, $state, arquivoService, $ionicFilterBar, $ionicFilterBarConfig, $filter, $ionicConfig){
                        $scope.filtro = {total: 10};

                        $scope.searcher = function(page, callback){
                            cifraService.busca(angular.extend($scope.filtro, {pagina: page}), callback);
                        };

                        $scope.showSearch = function(){
                            $ionicFilterBar.show({
                                items:[{}],
                                update: function(filter){

                                },
                                expression: function(filterText){
                                    if (filterText != $scope.filtro.filtro){
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
                    controller: function(cifraService, $scope, cifraService, pdfService, arquivoService, $timeout, $stateParams, $ionicScrollDelegate, $ionicLoading, $ionicSlideBoxDelegate, $filter){
                        cifraService.carrega($stateParams.id, function(cifra){
                            $scope.cifra = cifra;

                            if (!pdfService.progressoCache('cifra', cifra)){
                                pdfService.cache('cifra', cifra, function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                $ionicLoading.hide();
                            }

                            $scope.verificaExistencia = function(pagina){
                                var path = cordova.file.dataDirectory + 'arquivos/' + pagina.id + '.bin';
                                pagina.localPath = path;
                                var doVerificaExistencia = function (){
                                    arquivoService.exists(pagina.id, function(exists){
                                        if (exists){
                                            if (pagina.localPath != path){
                                                pagina.localPath = path;
                                            }
                                        }else{
                                            pagina.localPath = 'img/loading.gif';
                                            $timeout(doVerificaExistencia, 2000);
                                        }
                                    });
                                };

                                doVerificaExistencia();
                            };

                            cifra.paginas.forEach(function(pagina){
                                $scope.verificaExistencia(pagina);
                            });

                            $scope.slide = {activeSlide:null};

                            $scope.updateSlideStatus = function(index) {
                                var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
                                if (zoomFactor == 1) {
                                    $ionicSlideBoxDelegate.enableSlide(true);
                                } else {
                                    $ionicSlideBoxDelegate.enableSlide(false);
                                }
                            };
                        });
                    }
                }
            }
        });
    }]);
