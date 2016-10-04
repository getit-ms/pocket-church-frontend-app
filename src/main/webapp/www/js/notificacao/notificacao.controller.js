calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('notificacao', {
            parent: 'site',
            url: '/notificacao',
            views:{
                'content@':{
                    templateUrl: 'js/notificacao/notificacao.list.html',
                    controller: function(cacheService, $scope, $rootScope){
                        $scope.$on('$ionicView.enter', function(){
                            var notifications = cacheService.load('notifications');
                            if (!notifications){
                                notifications = {unread:0,messages:[]};
                            }
                            $rootScope.notifications = 0;
                            notifications.unread = 0;
                            $scope.messages = notifications.messages;
                            cacheService.save('notifications', null, notifications);
                        });
                    }
                }
            }
        });
    }]);
