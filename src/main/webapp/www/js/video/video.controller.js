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

                        $scope.openVideo = function(video) {
                            if (video.tipo == 'facebook') {
                              $window.open(video.streamUrl, '_system');
                            } else {
                              $window.open('https://www.youtube.com/watch?v=' + video.id, '_system');
                            }
                        };

                        $scope.busca();
                    }
                }
            }
        });
    }]);
