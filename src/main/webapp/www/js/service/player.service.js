calvinApp.service('playerService', ['arquivoService', '$q', '$filter', function(arquivoService, $q, $filter){

  this.callback = function(event) {
      const message = JSON.parse(action).message;
      switch(message) {
        case 'music-controls-next':
          // Do something
          break;
        case 'music-controls-previous':
          // Do something
          break;
        case 'music-controls-pause':
          self.pause();
          break;
        case 'music-controls-play':
          self.continue();
          break;
        case 'music-controls-destroy':
          self.stop();
          break;

        // External controls (iOS only)
        case 'music-controls-toggle-play-pause' :
          // Do something
          self.togglePlaying();
          break;
        case 'music-controls-seek-to':
          self.seekTo(Number(JSON.parse(action).position));
          break;

        // Headset events (Android only)
        // All media button events are listed below
        case 'music-controls-media-button' :
          self.togglePlaying();
          break;
        default:
          break;
      }
  };

  this.start = function(media) {
    var deferred = $q.defer();

    var self = this;

    this.track = media;
    this.loading = true;
    this.playing = false;

    this.media = new Media(media.url, function(event) {
      console.log(event);

    }, function(err) {
      self.track = undefined;
      self.loading = false;

      deferred.reject(err);
    }, function (status) {
      if (status = Media.MEDIA_RUNNING) {

        MusicControls.create({
          track       : media.titulo,
          artist      : media.artista,
          cover       : media.capa,
          isPlaying   : true,
          dismissable : true,

          hasPrev   : false,		// show previous button, optional, default: true
          hasNext   : false,		// show next button, optional, default: true
          hasClose  : true,		// show close button, optional, default: false

          // iOS only, optional
          duration : self.media.duration, // optional, default: 0
          elapsed : self.media.position, // optional, default: 0
          hasSkipForward : true, //optional, default: false. true value overrides hasNext.
          hasSkipBackward : true, //optional, default: false. true value overrides hasPrev.
          skipForwardInterval : 15, //optional. default: 0.
          skipBackwardInterval : 15, //optional. default: 0.

          // Android only, optional
          // text displayed in the status bar when the notification (and the ticker) are updated
          ticker	  : $filter('translate')('audio.ticker_tocando', {titulo: media.titulo})
        }, function(event) {
          console.log(event);

          self.loading = false;
          self.playing = true;

          MusicControls.subscribe(self.callback);

          MusicControls.listen();

          self.configureStatusTimeout();

          deferred.resolve({
          });
        }, function(err) {
          self.track = undefined;
          self.loading = false;

          self.media.stop();

          deferred.reject(err);
        });
      }
    });

    return deferred.promise;
  };

  this.continue = function () {
    if (this.media) {
      MusicControls.updateIsPlaying(true);
      MusicControls.updateDismissable(false);
      this.media.play();
      this.playing = true;
    }
  };

  this.togglePlaying = function() {
    if (this.media) {
      if (this.playing) {
        this.pause();
      } else {
        this.continue();
      }
    }
  };

  this.pause = function () {
    if (this.media) {
      MusicControls.updateIsPlaying(false);
      MusicControls.updateDismissable(true);
      this.media.pause();
      this.playing = false;
    }
  };

  this.stop = function() {
    if (this.media) {
      MusicControls.destroy(function() {
        console.log(event);
      }, function(err) {

      });

      this.media.stop();

      this.playing = false;
    }
  };

  this.seekTo = function(sec) {
    if (this.media) {
      MusicControls.updateElapsed({
        elapsed: sec
      });
      this.media.seekTo(sec * 1000);
    }
  };

  this.configureStatusTimeout = function() {
    var self = this;

    clearInterval(self.statusInterval);

    self.statusInterval = setInterval(function() {

      self.media.getCurrentPosition(function(pos) {
        MusicControls.updateElapsed({
          elapsed: pos,
          isPlaying: true
        });
      });


    }, 1000);
  }

}]);
