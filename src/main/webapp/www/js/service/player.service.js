calvinApp.service('playerService', ['arquivoService', function(arquivoService){

  this.playStream = function(stream, successCallback, failureCallback){
    window.audioplayer.playstream(
      successCallback,
      failureCallback,
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
  };

  this.playFile = function(arquivo, successCallback, failureCallback) {
    window.audioplayer.playfile( successCallback,
      failureCallback,
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
  };

  this.pause = function(successCallback, failureCallback) {
    window.audioplayer.pause( successCallback, failureCallback);
  };

  this.stop = function(successCallback, failureCallback) {
    window.audioplayer.stop( successCallback, failureCallback);
  };

}]);
