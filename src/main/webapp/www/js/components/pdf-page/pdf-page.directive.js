calvinApp.directive('pdfPage', function(){
  return {
    restrict: 'A',
    scope:{
      page:'=pdfPage'
    },
    link: function(scope, element, attrs, ctrl, transclude) {

      scope.load = function() {
        if (!scope.page) return;

        var canvas = element[0];

        var desiredWidth = canvas.offsetWidth;
        var viewport = scope.page.getViewport(1);
        var scale = desiredWidth / viewport.width;
        var scaledViewport = scope.page.getViewport(scale);

        // Prepare canvas using PDF page dimensions
        var context = canvas.getContext('2d');
        canvas.height = scaledViewport.height;
        canvas.width = scaledViewport.width;

        // Render PDF page into canvas context
        var renderContext = {
          canvasContext: context,
          viewport: scaledViewport
        };

        scope.page.render(renderContext);
      };

      scope.$watch(function() {
        return element[0].offsetWidth;
      }, function() {
        scope.load();
      });

      scope.$watch('page', function() {
        scope.load();
      });

      scope.load();
    }
  };
});
