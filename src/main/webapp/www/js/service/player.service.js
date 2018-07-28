calvinApp.service('playerService', ['arquivoService', '$q', function(arquivoService, $q){

  this.init = function() {
    var deferred = $q.defer();

    window.audioplayer.configure( function(event) {
      console.log('init', event);

      deferred.resolve({

      });
    }, function(err) {
      deferred.reject(err);
    });

    return deferred.promise;
  };

  this.playStream = function(stream){
    var deferred = $q.defer();

    window.audioplayer.playstream(
      function(event) {
        console.log('playStream', event);

        deferred.resolve({

        });
      },
      function(err) {
        deferred.reject(err);
      },
      // stream urls to play on android/ios
      {
        android: stream.url,
        ios: stream.url
      },
      // metadata used for iOS lock screen, Android 'Now Playing' notification
      {
        "title": stream.titulo,
        "artist": stream.artista,
        "image": {
          "url": stream.imagem
        },
        "name": stream.titulo,
        "description": stream.descricao
      },
      // javascript-specific json represenation of audio to be played, which will be passed back to
      // javascript via successCallback when a stream is launched from a local notification (eg, the
      // alarm clock
      stream
    );

    return deferred.promise;
  };

  this.playFile = function(file) {
    var deferred = $q.defer();

    window.audioplayer.playfile(
      function(event) {
        console.log('playFile', event);

        deferred.resolve({

        });
      },
      function(err) {
        deferred.reject(err)
      },
      file.arquivo,
      // metadata used for iOS lock screen, Android 'Now Playing' notification
      {
        "title": file.titulo,
        "artist": file.artista,
        "image": {
          "url": file.imagem
        }
      }
    );

    return deferred.promise;
  };

  this.pause = function() {
    var deferred = $q.defer();

    window.audioplayer.pause( function(event) {
      console.log('pause', event);

      deferred.resolve({

      });
    }, function(err) {
      deferred.reject(err);
    });

    return deferred.promise;
  };

  this.stop = function() {
    var deferred = $q.defer();

    window.audioplayer.stop( function(event) {
      console.log('stop', event);

      deferred.resolve({

      });
    }, function(err) {
      deferred.reject(err);
    });

    return deferred.promise;
  };

  this.seek = function(seconds) {
    var deferred = $q.defer();

    window.audioplayer.seek( function(event) {
      console.log('seek', event);

      deferred.resolve({

      });
    }, function(err) {
      deferred.reject(err);
    }, seconds );

    return deferred.promise;
  };

  this.seekTo = function(seconds) {
    var deferred = $q.defer();

    window.audioplayer.seekto( function(event) {
      console.log('seekTo', event);

      deferred.resolve({

      });
    }, function(err) {
      deferred.reject(err);
    }, seconds );

    return deferred.promise;
  };

  this.state = function() {
    var deferred = $q.defer();

    window.audioplayer.getaudiostate( function(event) {
      console.log('state', event);

      deferred.resolve({

      });
    }, function(err) {
      deferred.reject(err);
    } );

    return deferred.promise;
  }

}]);
