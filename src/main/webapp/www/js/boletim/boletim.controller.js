calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('boletim', {
            parent: 'site',
            url: '/boletim',
            views:{
                'content@':{
                    templateUrl: 'js/boletim/boletim.list.html',
                    controller: function(boletimService, $scope, $state, arquivoService){

                        $scope.searcher = function(page, callback){
                            boletimService.busca({
                                pagina: page, total: 10
                            }, function(boletins){
                                boletins.resultados.forEach(function(boletim){
                                    boletim.thumbnail.localPath = 'img/loading.gif';
                                    arquivoService.exists(boletim.thumbnail.id, function(exists){
                                        if (exists){
                                            boletim.thumbnail.localPath = cordova.file.cacheDirectory + 'arquivos/' + boletim.thumbnail.id + '.bin';
                                        }else{
                                            arquivoService.download(boletim.thumbnail.id, function(){
                                                boletim.thumbnail.localPath = cordova.file.cacheDirectory + 'arquivos/' + boletim.thumbnail.id + '.bin';
                                            }, cordova.file.cacheDirectory);
                                        }
                                    }, cordova.file.cacheDirectory);
                                });

                                callback(boletins);
                            });
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

                            if (!pdfService.progressoCache('boletim', boletim.id)){
                                pdfService.cache('boletim', boletim, function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                $ionicLoading.hide();
                            }

                            $scope.verificaExistencia = function(pagina){
                                pagina.localPath = 'img/loading.gif';
                                var doVerificaExistencia = function (){
                                    arquivoService.exists(pagina.id, function(exists){
                                        if (exists){
                                            pagina.localPath = cordova.file.dataDirectory + 'arquivos/' + pagina.id + '.bin';
                                        }else{
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
