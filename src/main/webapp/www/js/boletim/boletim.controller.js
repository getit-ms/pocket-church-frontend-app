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
                    controller: function(boletimService, $scope, pdfService, $stateParams, shareService, config,
                                        $ionicSlideBoxDelegate, $ionicScrollDelegate, loadingService, $filter){
                        $scope.totalPaginas = 0;

                        pdfService.get({
                            chave:'boletim',
                            id:$stateParams.id,
                            errorState:'boletim',
                            callback:function(boletim){
                                $scope.boletim = boletim;
                                $scope.totalPaginas = boletim.paginas.length;
                            },
                            supplier:function(id, callback){
                                boletimService.carrega(id, callback);
                            }
                        });

                        $scope.share = function(){
                            loadingService.show();

                            shareService.share({
                                subject:$scope.boletim.titulo,
                                file:config.server + '/rest/arquivo/download/' + 
                                        $scope.boletim.boletim.id + '/' +
                                        $scope.boletim.boletim.filename + '?Dispositivo=' +
                                    config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                                success: loadingService.hide,
                                error: loadingService.hide
                            });
                        };
                        
                        $scope.show = function(pagina, index){
                            var idx = $scope.boletim.paginas.indexOf(pagina);
                            return Math.abs(idx - index) <= 1;
                        };

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
