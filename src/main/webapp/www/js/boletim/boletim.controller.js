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
                                boletins.forEach(function(boletim){
                                    arquivoService.get(boletim.thumbnail.id, function(file){
                                        boletim.thumbnail.localPath = file.file;
                                    });
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
                    controller: function(boletimService, $scope, boletimService, pdfService, $stateParams, $ionicScrollDelegate, $ionicSlideBoxDelegate){
                        pdfService.get('boletim', function(boletim){
                            $scope.boletim = boletim;
                        }, function(id, callback){
                            boletimService.carrega(id, function(boletim){
                                callback(boletim);
                            });
                        }, $stateParams.id);

                        $scope.slide = {activeSlide:null};

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
