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
                                $scope.$broadcast('scroll.refreshComplete');
                            });
                        };
                        
                        $scope.openModal = function(video) {
                            $scope.video = video;
                            
                            $ionicModal.fromTemplateUrl('js/youtube/youtube.modal.html', {
                                scope: $scope,
                                animation: 'slide-in-up'
                            }).then(function(modal) {
                                $scope.modal = modal;
                                $scope.modal.show();
                            });
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
