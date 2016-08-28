calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('boletim', {
            parent: 'site',
            url: '/boletim',
            views:{
                'content@':{
                    templateUrl: 'js/boletim/boletim.list.html',
                    controller: function(boletimService, $scope, $state, arquivoService){
                        
                        $scope.searcher = function(page, callback){
                            boletimService.busca({pagina: page, total: 10}, callback);
                        };
                        
                        $scope.thumbnail = function(boletim){
                            if (!boletim.thumbnail.localPath){
                                boletim.thumbnail.localPath = '#';
                                arquivoService.get(boletim.thumbnail.id, function(file){
                                    boletim.thumbnail.localPath = file.file;
                                });
                            }
                            return boletim.thumbnail.localPath;
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
                    controller: function(boletimService, $scope, boletimService, pdfService, $stateParams, $ionicScrollDelegate, $ionicSlideBoxDelegate){
                        pdfService.get('boletim', $stateParams.id, function(boletim){
                            $scope.boletim = boletim;
                        }, boletimService.carrega);

                        $scope.slide = {activeSlide:null};

                        $scope.updateSlideStatus = function(index) {
                            var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
                            if (zoomFactor == 1) {
                                $ionicSlideBoxDelegate.enableSlide(true);
                                $scope.zoom = false;
                            } else {
                                $ionicSlideBoxDelegate.enableSlide(false);
                                $scope.zoom = true;
                            }
                        };
                    }
                }
            }
        });
    }]);
