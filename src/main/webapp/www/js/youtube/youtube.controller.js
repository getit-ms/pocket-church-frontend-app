calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('youtube', {
            parent: 'site',
            url: '/youtube',
            views:{
                'content@':{
                    templateUrl: 'js/youtube/youtube.list.html',
                    controller: function(youtubeService, $scope, $ionicModal, shareService){
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

                        $scope.share = function(){
                            if ($scope.video){
                                shareService.share({subject:$scope.video.titulo,link:'https://www.youtube.com/watch?v=' + $scope.video.id});
                            }
                        };

                        $scope.$on('$ionicView.leave', function() {
                            $scope.closeModal();
                        });

                        $scope.closeModal = function() {
                            if ($scope.player){
                                $scope.player.stopVideo();
                            }

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
