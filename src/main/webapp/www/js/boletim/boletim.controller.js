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
                        
                        $scope.cache = function(id){
                            if (!arquivoService.exists(id)){
                                arquivoService.download(id, function(){}, cordova.file.cacheDirectory);
                            }
                            return id;
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
                controller: function(boletimService, $scope, boletim, $ionicScrollDelegate, $ionicLoading, $ionicSlideBoxDelegate){
                        if (!boletimService.progressoCache(boletim.id) == 1){
                            $ionicLoading.show({template:'<ion-spinner icon="spiral" class="spinner spinner-spiral"></ion-spinner> ' + $filter('translate')('global.carregando')});
                            boletimService.cache(boletim.id, function(){
                                $ionicLoading.hide();
                            });
                        };
                    
                        $scope.boletim = boletim;
                        
                        $scope.slide = {activeSlide:null};
                        
                        $scope.updateSlideStatus = function(index) {
                            var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
                            if (zoomFactor == 1) {
                                $ionicSlideBoxDelegate.enableSlide(true);
                            } else {
                                $ionicSlideBoxDelegate.enableSlide(false);
                            }
                        };
                    },
                    resolve: {
                        boletim: ['boletimService', '$stateParams', function(boletimService, $stateParams){
                            return boletimService.carrega($stateParams.id);
                        }]
                    }
                }
            }
        });         
    }]);
