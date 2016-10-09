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
                                notificacoes.resultados.forEach(function(n){
                                    ns.push(angular.extend(n, angular.fromJson(n.notificacao)));
                                });
                                $cordovaBadge.set(0);
                                $rootScope.notifications = 0;
                                callback(angular.extend(notificacoes, {resultados:ns}));
                            });
                        };
                        
                        $scope.clear = function(){
                            $ionicPopup.confirm({
                                title:$filter('translate')('notificacao.confirmacao_exclusao'),
                                template:$filter('translate')('mensagens.MSG-043', {
                                    data:$filter('date')(agendamento.dataHoraInicio, 
                                    $filter('translate')('config.pattern.date')),
                                    horaInicio:$filter('date')(agendamento.dataHoraInicio, 
                                    $filter('translate')('config.pattern.hour')),
                                    horaFim:$filter('date')(agendamento.dataHoraFim, 
                                    $filter('translate')('config.pattern.hour'))
                                }),
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
