calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('youtube', {
            parent: 'site',
            url: '/youtube',
            views:{
                'content@':{
                    templateUrl: 'js/youtube/youtube.list.html',
                    controller: function(youtubeService, $scope, $ionicModal){
                        $scope.busca = function(){
                            $scope.futuros = [];
                            $scope.presentes = [];
                            $scope.passados = [];
                            youtubeService.busca(function(videos){
                                videos.forEach(function(v){
                                    if (v.aoVivo){
                                        $scope.presentes.push(v);
                                    }else if (v.agendamento){
                                        $scope.futuros.push(v);
                                    }else{
                                        $scope.passados.push(v);
                                    }
                                });
                                
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
                        
                        $scope.$on('$ionicView.leave', function() {
                            $scope.$scope.closeModal();
                        });

                        $scope.closeModal = function() {
                            if ($scope.modal){
                                $scope.modal.hide();
                                $scope.modal.remove();
                            }
                            $scope.video = undefined;
                        };
                        
                        $scope.busca();
                    }
                }
            }
        });         
    }]);
