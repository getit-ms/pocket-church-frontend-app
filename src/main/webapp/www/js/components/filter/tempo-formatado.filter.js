calvinApp
.filter('tempoFormatado', function(){
    return function(secs){
      secs = secs || 0;

      var min = Math.floor(secs / 60);
      var seg = Math.floor(secs % 60);

      return (min < 10 ? '0' + min : min) + ':' + (seg < 10 ? '0' + seg : seg);
    }
});
