calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('boletim', {
            parent: 'site',
            url: '/boletim',
            views:{
                'content@':{
                    templateUrl: 'js/boletim/boletim.list.html',
                    controller: function(boletimService, $scope, $ionicModal, arquivoService, pdfService, loadingService, shareService, config){

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
                            $ionicModal.fromTemplateUrl('js/boletim/boletim.form.html', {
                                scope: $scope,
                                animation: 'slide-in-up'
                            }).then(function(modal) {
                                $scope.modal = modal;
                                
                                pdfService.get({
                                    chave:'boletim',
                                    id: boletim.id,
                                    errorState:'boletim',
                                    callback:function(boletim){
                                        if (!$scope.boletim || !boletim.ultimaAlteracao ||
                                                boletim.ultimaAlteracao.getTime() !=
                                                $scope.boletim.ultimaAlteracao.getTime()){
                                            $scope.boletim = boletim;
                                            $scope.modal.show();
                                        }
                                    },
                                    supplier:function(id, callback){
                                        boletimService.carrega(id, callback);
                                    }
                                });

                            });
                        };

                        $scope.share = function(){
                            if (!$scope.boletim) return;

                            loadingService.show();

                            shareService.share({
                                subject:$scope.boletim.titulo,
                                file:config.server + '/rest/arquivo/download/' + $scope.boletim.boletim.id + '?Dispositivo=' +
                                    config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                                success: loadingService.hide,
                                error: loadingService.hide
                            });
                        };
                        
                        $scope.$on('$ionicView.leave', function() {
                            $scope.closeModal();
                        });

                        $scope.closeModal = function() {
                            if ($scope.modal){
                                $scope.modal.hide();
                                $scope.modal.remove();
                            }

                            $scope.boletim = undefined;
                        };
                        
                    }
                }
            }
        });
    }]);
