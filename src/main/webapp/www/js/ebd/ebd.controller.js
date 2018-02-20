calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('ebd', {
        parent: 'site',
        url: '/ebd',
        views:{
            'content@':{
                templateUrl: 'js/ebd/ebd.list.html',
                controller: function(eventoService, $state, $scope){
                    $scope.searcher = function(page, callback){
                        eventoService.busca({tipo:'EBD',pagina:page,total:10}, callback);
                    };

                    $scope.detalhar = function(ebd){
                        $state.go('ebd.detalhe', {id: ebd.id});
                    };
                }
            }
        }
    }).state('ebd.detalhe', {
        parent: 'ebd',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/ebd/ebd.form.html',
                controller: function($scope, ebd, $state, eventoService, arquivoService){
                    $scope.ebd = ebd;

                    $scope.searcherInscricoes = function(page, callback){
                        eventoService.buscaMinhasInscricoes(ebd.id, {pagina:page,total:10}, callback);
                    };


                  $scope.zoomBaanner = function() {
                    $ionicModal.fromTemplateUrl('js/ebd/banner.modal.html', {
                      scope: $scope,
                      animation: 'slide-in-up'
                    }).then(function(modal) {
                      $scope.modal = modal;
                      $scope.modal.show();
                    });
                  };

                  $scope.closeModal = function() {
                    if ($scope.modal){
                      $scope.modal.hide();
                      $scope.modal.remove();
                    }
                  };

                  $scope.updateSlideStatus = function(index) {
                    var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
                    if (zoomFactor == 1) {
                      $ionicSlideBoxDelegate.enableSlide(true);
                    } else {
                      $ionicSlideBoxDelegate.enableSlide(false);
                    }
                  };

                  $scope.banner = function(ebd){
                      if (!ebd || !ebd.banner) {
                        return undefined;
                      }

                      if (!ebd.banner.localPath){
                        ebd.banner.localPath = '#';
                        arquivoService.get(ebd.banner.id, function(file){
                          ebd.banner.localPath = file.file;
                        }, function(file){
                          ebd.banner.localPath = file.file;
                        }, function(file){
                          ebd.banner.localPath = file.file;
                        });
                      }

                      return ebd.banner.localPath;
                    };

                    $scope.$on('$ionicView.enter', function(){
                        $scope.$broadcast('pagination.search');
                    });

                    $scope.inscricao = function(){
                        $state.go('ebd.inscricao', {id: $scope.ebd.id});
                    };
                },
                resolve: {
                    ebd: ['eventoService', '$stateParams', function(eventoService, $stateParams){
                        return eventoService.carrega($stateParams.id);
                    }]
                }
            }
        }
    }).state('ebd.inscricao', {
        parent: 'ebd',
        url: '/:id/inscricao',
        views:{
            'content@':{
                templateUrl: 'js/ebd/inscricao.form.html',
                controller: function(eventoService, $scope, ebd, loadingService,
                                message, $window, $ionicHistory){
                    $scope.ebd = ebd;

                    $scope.$on('$ionicView.enter', function(){
                        $scope.clear();
                    });

                    $scope.clear = function(){
                        $scope.inscricoes = [];
                        $scope.addInscricao();
                    };

                    $scope.addInscricao = function(){
                        if ($scope.ebd.vagasRestantes > $scope.inscricoes.length){
                            if ($scope.inscricoes.length){
                                $scope.inscricoes.push({});
                            }else{
                                $scope.inscricoes.push({
                                    nomeInscrito: $scope.usuario.nome,
                                    emailInscrito: $scope.usuario.email,
                                    telefoneInscrito: $scope.usuario.telefones &&
                                            $scope.usuario.telefones.length ?
                                    $scope.usuario.telefones[0] : ''
                                });
                            }
                        }
                    };

                    $scope.removeInscricao = function(inscricao){
                        $scope.inscricoes.splice($scope.inscricoes.indexOf(inscricao), 1);
                    };

                    $scope.conclui = function(){
                        if ($scope.inscricoes.length){
                            loadingService.show();

                            eventoService.inscricao($scope.ebd.id, $scope.inscricoes, function(resposta){
                                loadingService.hide();

                                if (resposta.devePagar && resposta.checkoutPagSeguro){
                                    message({title: 'global.title.200',template: 'mensagens.MSG-042'}, function(){
                                        $ionicHistory.goBack();
                                        $window.open('https://pagseguro.uol.com.br/v2/checkout/payment.html?code=' + resposta.checkoutPagSeguro, '_system');
                                    });
                                }else{
                                    message({title: 'global.title.200',template: 'mensagens.MSG-001'});
                                    $ionicHistory.goBack();
                                }
                            }, function(){
                                loadingService.hide();
                            });
                        }
                    };

                    $scope.clear();
                },
                resolve: {
                    ebd: ['eventoService', '$stateParams', function(eventoService, $stateParams){
                        return eventoService.carrega($stateParams.id);
                    }]
                }
            }
        }
    });
}]);
