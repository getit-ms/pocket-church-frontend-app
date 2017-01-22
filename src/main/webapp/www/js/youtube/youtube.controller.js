calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('youtube', {
            parent: 'site',
            url: '/youtube',
            views:{
                'content@':{
                    templateUrl: 'js/youtube/youtube.list.html',
                    controller: function(youtubeService, $scope, $ionicModal){
                        $scope.busca = function(){
                            youtubeService.busca(function(videos){
                                $scope.videos = videos;
                            });
                            
                            $scope.$broadcast('scroll.refreshComplete');
                        };
                        
                        $ionicModal.fromTemplateUrl('youtube.modal.html', {
                            scope: $scope,
                            animation: 'slide-in-up'
                        }).then(function(modal) {
                            $scope.modal = modal;
                        });
                        
                        $scope.openModal = function(video) {
                            $scope.video = video;
                            $scope.modal.show();
                        };
                        
                        $scope.closeModal = function() {
                            $scope.modal.hide();
                            $scope.video = undefined;
                        };
                        
                        $scope.busca();
                    }
                }
            }
        });         
    }]);
