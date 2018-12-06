calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('youtube', {
            parent: 'site',
            url: '/youtube',
            views:{
                'content@':{
                    templateUrl: 'js/video/video.list.html',
                    controller: function(facebookService, youtubeService, $scope, $ionicModal, shareService){
                        $scope.busca = function(){
                            $scope.futuros = [];
                            $scope.presentes = [];
                            $scope.passados = [];

                            facebookService.busca(function(videos) {
                              angular.forEach(videos, function(v){
                                v.tipo = 'facebook';
                                if (v.aoVivo) {
                                  $scope.presentes.push(v);
                                } else {
                                  $scope.futuros.push(v);
                                }
                              });
                            });

                            youtubeService.busca(function(videos){
                              angular.forEach(videos, function(v){
                                v.tipo = 'youtube';
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

                            if (video.tipo == 'facebook') {
                              $window.open(video.streamUrl, '_system');
                            } else {
                              $ionicModal.fromTemplateUrl('js/video/youtube.modal.html', {
                                scope: $scope,
                                animation: 'slide-in-up'
                              }).then(function(modal) {
                                $scope.modal = modal;
                                $scope.modal.show();
                              });
                            }
                        };

                        $scope.share = function(){
                            if ($scope.video){
                              if ($scope.video.tipo == 'facebook') {

                              } else {
                                shareService.share({subject:$scope.video.titulo,link:'https://www.youtube.com/watch?v=' + $scope.video.id});
                              }
                            }
                        };

                        $scope.$on('modal.hidden', function() {
                          $scope.closeModal();
                        });

                        $scope.$on('$ionicView.leave', function() {
                            $scope.closeModal();
                        });

                        $scope.closeModal = function() {
                            if ($scope.player){
                                $scope.player.stopVideo();
                              $scope.player = undefined;
                            }

                            if ($scope.modal){
                                var modal = $scope.modal;

                                $scope.modal = undefined;

                                modal.hide();
                                modal.remove();
                            }

                            $scope.video = undefined;
                        };

                        $scope.busca();
                    }
                }
            }
        });
    }]);
