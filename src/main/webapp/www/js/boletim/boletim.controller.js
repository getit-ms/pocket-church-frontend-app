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
                        
                        $scope.show = function(pagina, index){
                            var idx = $scope.boletim.paginas.indexOf(pagina);
                            return Math.abs(idx - index) <= 1;
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
                    controller: function(boletimService, $scope, boletimService, pdfService, $state, $stateParams, $ionicScrollDelegate, $ionicSlideBoxDelegate){
                        $scope.totalPaginas = 0;
                        pdfService.get({
                            chave:'boletim', 
                            id:$stateParams.id, 
                            errorState:'boletim',
                            callback:function(boletim){
                                if (!$scope.boletim || !boletim.ultimaAlteracao ||
                                        boletim.ultimaAlteracao.getTime() != 
                                        $scope.ultimaAlteracao.getTime()){
                                    $scope.boletim = boletim;
                                    $scope.totalPaginas = boletim.paginas.length;
                                }
                            }, 
                            supplier:function(id, callback){
                                boletimService.carrega(id, callback);
                            }
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
                    }
                }
            }
        });
    }]);
