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
                                for (var boletim in boletins){
                                    boletim.thumbnail.localPath = 'img/loading.gif';
                                    arquivoService.exists(id, function(exists){
                                        if (exists){
                                            boletim.thumbnail.localPath = cordova.file.cacheDirectory + 'arquivos/' + id + '.bin';
                                        }else{
                                            arquivoService.download(id, function(){
                                                boletim.thumbnail.localPath = cordova.file.cacheDirectory + 'arquivos/' + id + '.bin';
                                            }, cordova.file.cacheDirectory);
                                        }
                                    }, cordova.file.cacheDirectory);
                                }
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
                    controller: function(boletimService, $scope, boletimService, arquivoService, $timeout, $stateParams, $ionicScrollDelegate, $ionicLoading, $ionicSlideBoxDelegate, $filter){
                        $ionicLoading.show({template:'<ion-spinner icon="spiral" class="spinner spinner-spiral"></ion-spinner> ' + $filter('translate')('global.carregando')});
						
                        boletimService.carrega($stateParams.id, function(boletim){
                            $scope.boletim = boletim;

                            if (!boletimService.progressoCache(boletim.id)){
                                boletimService.cache(boletim, function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                $ionicLoading.hide();
                            }
                            
                            $scope.verificaExistencia = function(pagina){
                                var doVerificaExistencia = function (){
                                    arquivoService.exists(pagina.id, function(exists){
                                        if (exists){
                                            pagina.localPath = cordova.file.dataDirectory + 'arquivos/' + id + '.bin';
                                        }else{
                                            $timeout(doVerificaExistencia, 2000);
                                        }
                                    });
                                };
                                
                                doVerificaExistencia();
                            };
                            
                            for (var pagina in boletim.paginas){
                                boletim.thumbnail.localPath = 'img/loading.gif';
                                $scope.verificaExistencia(pagina);
                            }
						
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
