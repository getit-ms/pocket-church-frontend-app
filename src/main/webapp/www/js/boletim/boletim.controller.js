calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('boletim', {
            parent: 'site',
            url: '/boletim',
            views:{
                'content@':{
                    templateUrl: 'js/boletim/boletim.list.html',
                    controller: function(boletimService, $scope, $state, arquivoService){

                        $scope.boletins = [];
                        
                        $scope.$watch('boletins', function(boletins){
                            boletins.forEach(function(boletim){
                                var path = cordova.file.cacheDirectory + 'arquivos/' + boletim.thumbnail.id + '.bin';
                                arquivoService.exists(boletim.thumbnail.id, function(exists){
                                    if (exists){
                                        if (boletim.thumbnail.localPath != path){
                                            boletim.thumbnail.localPath = path;
                                        }
                                    }else{
                                        boletim.thumbnail.localPath = 'img/loading.gif';
                                        arquivoService.download(boletim.thumbnail.id, function(){
                                            boletim.thumbnail.localPath = path;
                                        }, cordova.file.cacheDirectory);
                                    }
                                }, cordova.file.cacheDirectory);
                            });
                        });

                        $scope.searcher = function(page, callback){
                            boletimService.busca({
                                pagina: page, total: 10
                            }, callback);
                        };

                        $scope.detalhar = function(boletim){
                            $state.go('boletim.view', {id: boletim.id});
                        };
                    }
                }
            }
        }).state('boletim.view', {
            parent: 'boletim',
            url: '/:id',
            views:{
                'content@':{
                    templateUrl: 'js/boletim/boletim.form.html',
                    controller: function(boletimService, $scope, boletimService, pdfService, arquivoService, $timeout, $stateParams, $ionicScrollDelegate, $ionicLoading, $ionicSlideBoxDelegate, $filter){
                        $ionicLoading.show({template:'<ion-spinner icon="spiral" class="spinner spinner-spiral"></ion-spinner> ' + $filter('translate')('global.carregando')});

                        boletimService.carrega($stateParams.id, function(boletim){
                            $scope.boletim = boletim;

                            if (!pdfService.progressoCache('boletim', boletim)){
                                pdfService.cache('boletim', boletim, function(){
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

                            boletim.paginas.forEach(function(pagina){
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
