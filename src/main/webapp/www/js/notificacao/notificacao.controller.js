calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('notificacao', {
            parent: 'site',
            url: '/notificacao',
            views:{
                'content@':{
                    templateUrl: 'js/notificacao/notificacao.list.html',
                    controller: function(notificacaoService, $scope, $rootScope, $cordovaBadge, $ionicPopup, $filter, message){
                        $scope.searcher = function(page, callback){
                            notificacaoService.busca({pagina: page, total: 10}, function(notificacoes){
                                var ns = [];
                                if (notificacoes.resultados){
                                    notificacoes.resultados.forEach(function(n){
                                        var diff = diferenca(new Date(), msg.data);
                                        if (diff == 0){
                                            n.dataFormatada = $filter('translate')('notificacao.hoje');
                                        }else if (diff == 1){
                                            n.dataFormatada = $filter('translate')('notificacao.ontem');
                                        }else{
                                            n.dataFormatada = $filter('date')(msg.data, $filter('translate')('notificacao.data_pattern'));
                                        }
                                        
                                        ns.push(angular.extend(n, angular.fromJson(n.notificacao)));
                                    });
                                }
                                $cordovaBadge.set(0);
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
                            $scope.excluir = [];
                        };
                        
                        $scope.confirmarExclusao = function(){
                            if ($scope.excluir && $scope.excluir.length){
                                $ionicPopup.confirm({
                                    title:$filter('translate')('notificacao.confirmacao_exclusao'),
                                    template:$filter('translate')('mensagens.MSG-043'),
                                    okText:$filter('translate')('global.sim'),
                                    cancelText:$filter('translate')('global.nao')
                                }).then(function(resp){
                                    if (resp){
                                        if ($scope.excluirTodos){
                                            notificacaoService.clear(function(){
                                                message({title:'global.title.200',template:'mensagens.MSG-001'});
                                                $scope.$broadcast('pagination.search');
                                            });
                                        }else{
                                            $scope.excluir.forEach(function(e){
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
                            if ($scope.excluir.indexOf(message) >= 0){
                                $scope.splice($scope.excluir.indexOf(message), 1);
                            }else{
                                $scope.excluir.push(message);
                            }
                        };
                        
                        $scope.atualizaExcluirTodos = function(){
                            $scope.excluir.clear();
                            if ($scope.excluirTodos){
                                $scope.messages.forEach(function(m){
                                    $scope.excluir.push(m);
                                });
                            }
                        };
                        
                        $scope.cancelarExclusao = function(){
                            $scope.excluir = undefined;
                        };
                        
                        $scope.$on('$ionicView.enter', function(){
                            $scope.$broadcast('pagination.search');
                        });
                    }
                }
            }
        });
    }]);
