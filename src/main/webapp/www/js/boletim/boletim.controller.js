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
                    controller: function(boletimService, $scope, boletimService, pdfService, $state, $stateParams, $ionicScrollDelegate, $ionicSlideBoxDelegate){
                        pdfService.get('boletim', $stateParams.id, function(boletim){
                            if ($scope.boletim){
                                var diff = $scope.boletim.paginas.length != boletim.paginas.length;
                                for (var i=0;i<boletim.paginas.length;i++){
                                    var found = false;
                                    for (var j=0;j<$scope.boletim.paginas.length;j++){
                                        if ($scope.boletim.paginas[j].id == boletim.paginas[i].id){
                                            found = true;
                                        }
                                    }
                                    if (!found){
                                        diff = true;
                                    }
                                }
                                
                                if (diff){
                                    $state.reload();
                                }
                            }else{
                                $scope.boletim = boletim;
                            }
                        }, function(id, callback){
                            boletimService.carrega(id, callback);
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
