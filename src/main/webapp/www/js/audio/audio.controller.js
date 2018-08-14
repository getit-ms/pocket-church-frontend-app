calvinApp.config(['$stateProvider', function($stateProvider){
  $stateProvider.state('audio', {
    parent: 'site',
    url: '/audio',
    views:{
      'content@':{
        templateUrl: 'js/audio/categoria.list.html',
        controller: function(audioService, $scope, playerService){
          $scope.buscaCategorias = function(){
            audioService.buscaCategorias(function(categorias){
              $scope.categorias = categorias;
            });
          };

          $scope.isPlaying = function(categoria) {
            return playerService.playing && playerService.track.categoria == categoria.id;
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
        controller: function(audioService, $scope, $stateParams, playerService, configService, arquivoService){
          $scope.searcher = function(page, callback){
            audioService.busca({categoria: $stateParams.categoria, pagina:page, total:10}, function(audios){
              $scope.categoria = audios.categoria;

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

          $scope.isLoading = function(audio) {
            return playerService.loading && playerService.track.id == audio.id;
          };

          $scope.isPlaying = function(audio) {
            return playerService.playing && playerService.track.id == audio.id;
          };

          $scope.isPaused = function(audio) {
            return playerService.paused && playerService.track.id == audio.id;
          };

          $scope.toggle = function(audio) {
            if ($scope.isPaused(audio)) {
              playerService.play();
            } else if ($scope.isPlaying(audio)) {
              playerService.pause();
            } else {
              configService.load().then(function(config) {
                var url = config.server + '/rest/arquivo/stream/' + audio.audio.id + '/' + audio.audio.filename +
                  '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja;

                var capa = undefined;
                if (audio.capa) {
                  capa = config.server + '/rest/arquivo/download/' + audio.capa.id + '/' + audio.capa.filename +
                    '?Dispositivo=' + config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja;
                }

                playerService.play({
                  id: audio.id,
                  url: url,
                  categoria: $stateParams.categoria,
                  titulo: audio.nome,
                  artista: audio.autor,
                  album: $scope.categoria.nome,
                  capa: capa,
                  duracao: audio.tempoAudio
                });
              });
            }

          };

        }
      }
    }
  });
}]);
