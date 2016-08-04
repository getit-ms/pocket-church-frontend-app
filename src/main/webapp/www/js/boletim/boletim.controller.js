calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('boletim', {
            parent: 'site',
            url: '/boletim',
            views:{
                'content@':{
                    templateUrl: 'js/boletim/boletim.list.html',
                controller: function(boletimService, $scope, $state, configService, $httpParamSerializer){
                    var config = configService.load();
                    $scope.server = config.server;
                    $scope.headers = $httpParamSerializer(config.headers);
                    
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
                controller: function($scope, boletim, $ionicScrollDelegate, configService, $httpParamSerializer, $ionicSlideBoxDelegate){
                    var config = configService.load();
                    $scope.server = config.server;
                    $scope.headers = $httpParamSerializer(config.headers);
                    
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
