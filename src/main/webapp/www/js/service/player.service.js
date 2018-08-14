calvinApp.service('playerService', ['arquivoService', '$q', '$filter', '$ionicPlatform', '$rootScope', '$ionicModal',
  function(arquivoService, $q, $filter, $ionicPlatform, $rootScope, $ionicModal){

    var self = this;

    this.callback = function(status) {
      switch(status.type) {
        case 10: // loading
        case 25: // buffering
          self.loading = true;
          break;

        case 35: // paused
          self.playing = false;
          self.paused = true;
          break;

        case 30: // playing
          self.paused = false;
        case 40: // playback position
          self.loading = false;
          self.playing = true;
          if (status.value && self.updatePosition) {
            self.position = status.value.currentPosition;
          }
          break;

        case 45: // seek
          self.play();
          break;

        case 50: // completed
        case 105: //playlist completed
          self.stop();
          break;

        case 60: // stopped
        case 120: // playlist cleared
        case 200: // view disappear
          self.loading = false;
          self.playing = false;
          self.paused = false;
          self.hidePlaying();
          break;

      }

      try {
        $rootScope.$apply();
      }catch(e){}
    };

    this.showPlaying = function() {
      if (this.loading || this.playing || this.paused) {
        var scope = $rootScope.$new();

        $ionicModal.fromTemplateUrl('js/audio/playing.modal.html', {
          scope: scope,
          animation: 'slide-in-up'
        }).then(function(modal) {
          $rootScope.playingModal = modal;
          $rootScope.playingModal.show();
        });
      }
    };

    this.hidePlaying = function() {
      if ($rootScope.playingModal){
        var modal = $rootScope.playingModal;

        $rootScope.playingModal = undefined;

        modal.hide().then(function(){
          modal.remove();
        });
      }
    };

    this.play = function(media) {
      var deferred = $q.defer();

      if (media) {

        var self = this;

        function doPlay() {
          self.track = media;
          self.loading = true;
          self.playing = false;

          window.plugins.AudioPlayer.AudioPlayer.setPlaylistItems(function(event) {
            console.log(event);

            deferred.resolve(event);
          }, function(err) {
            console.error(err);

            self.loading = false;

            deferred.reject(err);
          }, [{
            isStream: true,
            trackId     : media.url,
            assetUrl    : media.url,
            title       : media.titulo,
            artist      : media.artista,
            album       : media.album,
            albumArt    : media.capa
          }], {startPaused:false});
        }

        this.stop().then(doPlay, doPlay);

      } else {
        window.plugins.AudioPlayer.AudioPlayer.play();

        deferred.resolve();
      }

      return deferred.promise;
    };

    this.togglePlaying = function() {
      if (this.paused) {
        this.play();
      } else {
        this.pause();
      }
    };

    this.pause = function () {
      window.plugins.AudioPlayer.AudioPlayer.pause();
    };

    this.stop = function() {
      var deferred = $q.defer();

      this.pause();
      self.loading = false;
      self.playing = false;
      self.paused = false;
      self.hidePlaying();
      window.plugins.AudioPlayer.AudioPlayer
        .clearAllItems(function(){
          deferred.resolve();
        }, function(err){
          deferred.reject(err);
        });

      return deferred.promise;
    };

    this.updatePosition = true;

    this.seekTo = function(sec, successCallback, errorCallback) {
      var self = this;

      self.updatePosition = false;
      clearTimeout(self.seeking);

      self.seeking = setTimeout(function() {
        window.plugins.AudioPlayer.AudioPlayer.seekTo(function(){
          self.updatePosition = true;
          if (successCallback) {
            successCallback();
          }
        }, function(){
          self.updatePosition = true;
          if (errorCallback) {
            errorCallback();
          }
        }, sec)
      }, 350);
    };

    this.init = function() {
      $rootScope.playerStatus = this;
    };

    $ionicPlatform.on("deviceready", function() {
      window.plugins.AudioPlayer.AudioPlayer.on('status', self.callback);

      window.plugins.AudioPlayer.AudioPlayer.initialize();

      window.plugins.AudioPlayer.AudioPlayer.setOptions(function(){}, function(){}, {
        resetStreamOnPause: false
      });
    });

  }]);
