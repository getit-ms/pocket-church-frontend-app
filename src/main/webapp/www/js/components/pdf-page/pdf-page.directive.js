calvinApp.directive('pdfPage', function(){
  return {
    restrict: 'E',
    scope:{
      page:'='
    },
    templateUrl: 'js/components/pdf-page/pdf-page.html',
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
        scope.renderContext = {
          canvasContext: context,
          viewport: scaledViewport
        };

        scope.deveRenderizar = true;
        scope.renderiza(scope.inview);

      };

      scope.renderiza = function(inview) {
        scope.inview = inview;

        if (scope.inview && scope.deveRenderizar) {
          scope.page.render(scope.renderContext);
        }

        scope.deveRenderizar = false;
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
