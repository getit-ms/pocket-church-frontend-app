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
                            }, callback);
                        };
                        
                        $scope.detalhar = function(boletim){
                            $state.go('boletim.view', {id: boletim.id});
                        };
                        
                        $scope.thumbnail = function(id){
                            if (!arquivoService.exists(id, cordova.file.cacheDirectory)){
                                arquivoService.download(id, function(){}, cordova.file.cacheDirectory);
                            }
							
                            return cordova.file.cacheDirectory + 'arquivos/' + id + '.bin';
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
                    controller: function(boletimService, $scope, boletimService, $timeout, $stateParams, $ionicScrollDelegate, $ionicLoading, $ionicSlideBoxDelegate, $filter){
                        $ionicLoading.show({template:'<ion-spinner icon="spiral" class="spinner spinner-spiral"></ion-spinner> ' + $filter('translate')('global.carregando')});
						
                        boletimService.carrega($stateParams.id, function(boletim){
                            $scope.boletim = boletim;

                            if (!boletimService.progressoCache(boletim.id)){
                                boletimService.cache(boletim, function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                stopLoading();
                                
                                function stopLoading(){
                                    if (boletimService.progressoCache(boletim.id) == 1){
                                        $ionicLoading.hide();
                                    }else{
                                        $timeout(stopLoading, 1000);
                                    }
                                }
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
						
                        $scope.page = function(id){
                            return cordova.file.dataDirectory + 'arquivos/' + id + '.bin';
                        };
                    }
                }
            }
        });         
    }]);
