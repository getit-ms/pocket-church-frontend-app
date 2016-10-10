calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('notificacao', {
            parent: 'site',
            url: '/notificacao',
            views:{
                'content@':{
                    templateUrl: 'js/notificacao/notificacao.list.html',
                    controller: function(notificacaoService, $scope, $rootScope, $cordovaBadge, $ionicPopup, $filter){
                        $scope.searcher = function(page, callback){
                            notificacaoService.busca({pagina: page, total: 10}, function(notificacoes){
                                var ns = [];
                                if (notificacoes.resultados){
                                    notificacoes.resultados.forEach(function(n){
                                        ns.push(angular.extend(n, angular.fromJson(n.notificacao)));
                                    });
                                }
                                $cordovaBadge.set(0);
                                $rootScope.notifications = 0;
                                callback(angular.extend(notificacoes, {resultados:ns}));
                            });
                        };
                        
                        var dayMillis = 1000 * 60 * 60 * 24;
                        
                        $scope.showData = function(message, messages){
                            var idx = messages.indexOf(message);
                            return idx == 0 || diferenca(messages[idx - 1].data, message.data) >= 1;
                        };
                        
                        function diferenca(d1, d2){
                            return (d1.getTime() - d2.getTime()) / dayMillis;
                        }
                        
                        $scope.data = function(message){
                            var diff = diferenca(new Date(), message.data);
                            if (diff < 1){
                                return $filter('translate')('notificacao.hoje');
                            }else if (diff < 2){
                                return $filter('translate')('notificacao.ontem');
                            }
                            
                            return $filter('date')(message.data, $filter('translate')('notificacao.confirmacao_exclusao'));
                        };
                        
                        $scope.clear = function(){
                            $ionicPopup.confirm({
                                title:$filter('translate')('notificacao.confirmacao_exclusao'),
                                template:$filter('translate')('mensagens.MSG-043'),
                                okText:$filter('translate')('global.sim'),
                                cancelText:$filter('translate')('global.nao')
                            }).then(function(resp){
                                if (resp){
                                    notificacaoService.clear(function(){
                                        $scope.$broadcast('pagination.search');
                                    });
                                }
                            });
                        };
                        
                        $scope.$on('$ionicView.enter', function(){
                            $scope.$broadcast('pagination.search');
                        });
                    }
                }
            }
        });
    }]);
