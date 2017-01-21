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
                    controller: function(boletimService, $scope, boletimService, pdfService, $stateParams, shareService, config){
                        pdfService.get({
                            chave:'boletim', 
                            id:$stateParams.id, 
                            errorState:'boletim',
                            callback:function(boletim){
                                if (!$scope.boletim || !boletim.ultimaAlteracao ||
                                        boletim.ultimaAlteracao.getTime() != 
                                        $scope.ultimaAlteracao.getTime()){
                                    $scope.boletim = boletim;
                                }
                            }, 
                            supplier:function(id, callback){
                                boletimService.carrega(id, callback);
                            }
                        });
                        
                        $scope.share = function(){
                            shareService.share({subject:$scope.boletim.titulo,file:config.server + '/rest/arquivo/download/' + 
                                        $scope.boletim.boletim.id + '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja});
                        };
                        
                        $scope.toggleFullScreen = function(){
                            $scope.fullscreen = !$scope.fullscreen;
                        };
                    }
                }
            }
        });
    }]);
