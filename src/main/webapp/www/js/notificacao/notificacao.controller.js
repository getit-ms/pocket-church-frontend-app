calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('notificacao', {
            parent: 'site',
            url: '/notificacao',
            views:{
                'content@':{
                    templateUrl: 'js/notificacao/notificacao.list.html',
                    controller: function(notificacaoService, $scope, $rootScope, $cordovaBadge,
                        $ionicPopup, $filter, message, $state, shareService, $ionicPlatform){
                        $scope.searcher = function(page, callback){
                            notificacaoService.busca({pagina: page, total: 10}, function(notificacoes){
                                var ns = [];
                                if (notificacoes.resultados){
                                    notificacoes.resultados.forEach(function(n){
                                        var diff = diferenca(new Date(), n.data);
                                        if (diff == 0){
                                            n.dataFormatada = $filter('translate')('notificacao.hoje');
                                        }else if (diff == 1){
                                            n.dataFormatada = $filter('translate')('notificacao.ontem');
                                        }else{
                                            n.dataFormatada = $filter('date')(n.data, $filter('translate')('notificacao.data_pattern'));
                                        }

                                        ns.push(angular.extend(n, angular.fromJson(n.notificacao)));

                                        if (n.customData){
                                            switch (n.customData.tipo){
                                                case 'ACONSELHAMENTO':
                                                    n.state = 'agenda';
                                                    break;
                                                case 'BOLETIM':
                                                    n.state = 'boletim';
                                                    break;
                                                case 'EVENTO':
                                                    n.state = 'evento';
                                                    break;
                                                case 'PEDIDO_ORACAO':
                                                    n.state = 'oracao';
                                                    break;
                                            }
                                        }
                                    });
                                }
                                //$cordovaBadge.set(0);
                                $rootScope.notifications = 0;
                                callback(angular.extend(notificacoes, {resultados:ns}));
                            });
                        };

                        $scope.showData = function(message, messages){
                            var idx = messages.indexOf(message);
                            return idx == 0 || diferenca(messages[idx - 1].data, message.data) > 0;
                        };

                        function diferenca(d1, d2){
                            return day(d1) - day(d2);
                        }

                        function day(d){
                            return d.getFullYear() * 10000 + d.getMonth() * 100 + d.getDate();
                        }

                        $scope.clear = function(){
                            $scope.excluir = {todos:false,selecionados:[]};

                            $scope.deregisterHardBack = $ionicPlatform.
                                    registerBackButtonAction(function(){
                                $scope.cancelarExclusao();
                            });

                            $scope.$on('$destroy', function() {
                                $scope.cancelarExclusao();
                            });

                            $scope.$on('$ionicView.leave', function(){
                                $scope.cancelarExclusao();
                            });
                        };

                        $scope.acessar = function(message){
                            if (message.state){
                                $state.go(message.state);
                            }else if (message.customData && message.customData.compartilhavel){
                                shareService.share({message:message.message, subject:message.title});
                            }
                        };

                        $scope.confirmarExclusao = function(){
                            if ($scope.excluir && ($scope.excluir.todos || $scope.excluir.selecionados.length)){
                                var mensagemConfirmacao;
                                if ($scope.excluir.todos){
                                    mensagemConfirmacao = $filter('translate')('mensagens.MSG-043');
                                }else{
                                    mensagemConfirmacao = $filter('translate')('mensagens.MSG-047', {quantidade:$scope.excluir.selecionados.length});
                                }

                                $ionicPopup.confirm({
                                    title:$filter('translate')('notificacao.confirmacao_exclusao'),
                                    template: mensagemConfirmacao,
                                    okText:$filter('translate')('global.sim'),
                                    cancelText:$filter('translate')('global.nao')
                                }).then(function(resp){
                                    if (resp){
                                        if ($scope.excluir.todos){
                                            notificacaoService.clear(function(){
                                                message({title:'global.title.200',template:'mensagens.MSG-001'});
                                                $scope.$broadcast('pagination.search');
                                            });
                                        }else{
                                            $scope.excluir.selecionados.forEach(function(e){
                                                notificacaoService.remove(e.id);
                                            });

                                            message({title:'global.title.200',template:'mensagens.MSG-001'});
                                            $scope.$broadcast('pagination.search');
                                        }
                                        $scope.cancelarExclusao();
                                    }
                                });
                            }
                        };

                        $scope.toggleExcluir = function(message){
                            var idx = $scope.excluir.selecionados.indexOf(message);
                            if (idx >= 0){
                                $scope.excluir.selecionados.splice(idx, 1);
                            }else{
                                $scope.excluir.selecionados.push(message);
                            }
                        };

                        $scope.atualizaExcluirTodos = function(){
                            $scope.excluir.clear();
                            if ($scope.excluir.todos){
                                $scope.messages.forEach(function(m){
                                    $scope.excluir.selecionados.push(m);
                                });
                            }
                        };

                        $scope.cancelarExclusao = function(){
                            $scope.excluir = undefined;

                            if ($scope.deregisterHardBack){
                                $scope.deregisterHardBack();
                            }
                        };

                        $scope.$on('$ionicView.enter', function(){
                            $scope.$broadcast('pagination.search');
                        });
                    }
                }
            }
        });
    }]);
