calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('evento', {
        parent: 'site',
        url: '/evento',
        views:{
            'content@':{
                templateUrl: 'js/evento/evento.list.html',
                controller: function(eventoService, $state, $scope){
                    $scope.searcher = function(page, callback){
                        eventoService.busca({tipo:'EVENTO',pagina:page,total:10}, callback);
                    };

                    $scope.detalhar = function(evento){
                        $state.go('evento.detalhe', {id: evento.id});
                    };
                }
            }
        }
    }).state('evento.detalhe', {
        parent: 'evento',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/evento/evento.form.html',
                controller: function($scope, evento, $state, eventoService, $ionicModal, arquivoService){
                    $scope.evento = evento;

                    $scope.searcherInscricoes = function(page, callback){
                        eventoService.buscaMinhasInscricoes(evento.id, {pagina:page,total:10}, callback);
                    };

                  $scope.zoomBaanner = function() {
                    $ionicModal.fromTemplateUrl('js/evento/banner.modal.html', {
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

                  $scope.banner = function(evento){
                    if (!evento || !evento.banner) {
                      return undefined;
                    }

                    if (!evento.banner.localPath){
                      evento.banner.localPath = '#';
                      arquivoService.get(evento.banner.id, function(file){
                        evento.banner.localPath = file.file;
                      }, function(file){
                        evento.banner.localPath = file.file;
                      }, function(file){
                        evento.banner.localPath = file.file;
                      });
                    }

                    return evento.banner.localPath;
                  };

                    $scope.$on('$ionicView.enter', function(){
                        $scope.$broadcast('pagination.search');
                    });

                    $scope.inscricao = function(){
                        $state.go('evento.inscricao', {id: $scope.evento.id});
                    };
                },
                resolve: {
                    evento: ['eventoService', '$stateParams', function(eventoService, $stateParams){
                        return eventoService.carrega($stateParams.id);
                    }]
                }
            }
        }
    }).state('evento.inscricao', {
        parent: 'evento',
        url: '/:id/inscricao',
        views:{
            'content@':{
                templateUrl: 'js/evento/inscricao.form.html',
                controller: function(eventoService, $scope, evento, $state, $filter,
                                message, $window, $ionicHistory, loadingService){
                    $scope.evento = evento;

                    $scope.$on('$ionicView.enter', function(){
                        $scope.clear();
                    });

                    $scope.clear = function(){
                        $scope.inscricoes = [];
                        $scope.addInscricao();
                    };

                    $scope.addInscricao = function(){
                        if ($scope.evento.vagasRestantes > $scope.inscricoes.length){
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

                            eventoService.inscricao($scope.evento.id, $scope.inscricoes, function(resposta){
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
                    evento: ['eventoService', '$stateParams', function(eventoService, $stateParams){
                        return eventoService.carrega($stateParams.id);
                    }]
                }
            }
        }
    });
}]);
