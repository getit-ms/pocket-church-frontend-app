calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('evento', {
        parent: 'site',
        url: '/evento',
        views:{
            'content@':{
                templateUrl: 'js/evento/evento.list.html',
                controller: function(eventoService, $state, $scope){
                    $scope.searcher = function(page, callback){
                        eventoService.busca({pagina:page,total:10}, callback);
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
                controller: function($scope, evento, $state, eventoService){
                    $scope.evento = evento;
                    
                    $scope.searcherInscricoes = function(page, callback){
                        eventoService.buscaMinhasInscricoes(evento.id, {pagina:page,total:10}, callback);
                    };
                    
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
                controller: function(eventoService, $scope, evento, $state, 
                                message, $window, $ionicHistory){
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
                            eventoService.inscricao($scope.evento.id, $scope.inscricoes, function(resposta){
                                if (resposta.devePagar && resposta.checkoutPagSeguro){
                                    message({title: 'global.title.200',template: 'mensagens.MSG-042'}, function(){
                                        $ionicHistory.goBack();
                                        $window.open('https://pagseguro.uol.com.br/v2/checkout/payment.html?code=' + resposta.checkoutPagSeguro, '_system');
                                    });
                                }else{
                                    message({title: 'global.title.200',template: 'mensagens.MSG-001'});
                                    $ionicHistory.goBack();
                                }
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
        