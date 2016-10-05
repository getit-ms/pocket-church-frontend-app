calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('notificacao', {
            parent: 'site',
            url: '/notificacao',
            views:{
                'content@':{
                    templateUrl: 'js/notificacao/notificacao.list.html',
                    controller: function(notificacaoService, $scope, $rootScope){
                        $scope.refresh = function(){
                            $rootScope.notifications = notificacaoService.count(0);
                            $scope.messages = notificacaoService.get();
                            $scope.$broadcast('scroll.refreshComplete');
                        };
                        
                        $scope.$on('$ionicView.enter', function(){
                            $scope.refresh();
                        });
                    }
                }
            }
        });
    }]);
