calvinApp.config(['$stateProvider', function($stateProvider){
  $stateProvider.state('audio', {
    parent: 'site',
    url: '/audio',
    views:{
      'content@':{
        templateUrl: 'js/audio/categoria.list.html',
        controller: function(audioService, $scope, message, $ionicPopup, $filter, $ionicHistory, $state){
          $scope.buscaCategorias = function(){
            audioService.buscaCategorias(function(categorias){
              $scope.categorias = categorias;
            });
          };

          $scope.$on('$ionicView.enter', function(){
            $scope.buscaCategorias();
          });

        }
      }
    }
  }).state('audio.categoria', {
    parent: 'audio',
    url: '/:categoria',
    views:{
      'content@':{
        templateUrl: 'js/audio/audio.list.html',
        controller: function(audioService, $scope, $stateParams, playerService, configService, message, $ionicPopup, $filter, $ionicHistory, $state){
          $scope.searcher = function(page, callback){
            audioService.busca({categoria: $stateParams.categoria, pagina:page, total:10}, function(audios){
              callback(audios);
            });
          };

          $scope.$on('$ionicView.enter', function(){
            $scope.$broadcast('pagination.search');
          });

          $scope.capa = function(audio){
            if (!audio.capa) return 'img/home.png';

            if (!audio.capa.localPath){
              audio.capa.localPath = '#';
              arquivoService.get(audio.capa.id, function(file){
                audio.capa.localPath = file.file;
              }, function(file){
                audio.capa.localPath = file.file;
              }, function(file){
                audio.capa.localPath = file.file;
              });
            }
            return audio.capa.localPath;
          };

          $scope.play = function(audio) {
            configService.get().then(function(config) {
              var url = config.server + '/rest/arquivo/download/' + audio.audio.id + '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja;
              var capa = undefined;

              if (audio.capa) {
                capa = config.server + '/rest/arquivo/download/' + audio.capa.id + '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja;
              }

              playerService.playStream({
                url: url,
                titulo: audio.nome,
                artista: audio.autor,
                imagem: capa
              });
            });
          };

        }
      }
    }
  });
}]);
