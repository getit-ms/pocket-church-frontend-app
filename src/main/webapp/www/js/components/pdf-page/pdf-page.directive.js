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

        var canvas = element[0].children[0];

        var desiredWidth = canvas.offsetWidth;
        var viewport = scope.page.getViewport(1);
        var scale = desiredWidth / viewport.width;
        var scaledViewport = scope.page.getViewport(scale);

        // Prepare canvas using PDF page dimensions
        canvas.height = scaledViewport.height;
        canvas.width = scaledViewport.width;

        scope.deveRenderizar = !scope.scaledViewport ||
          scaledViewport.width > scope.scaledViewport.width;

        if (scope.deveRenderizar) {
          scope.scaledViewport = scaledViewport;
          scope.renderiza(scope.inview);
        }
      };

      scope.renderiza = function(inview) {
        scope.inview = inview;

        if (scope.inview && scope.deveRenderizar) {
          var canvas = element[0].children[0];

          var context = canvas.getContext('2d');

          // Render PDF page into canvas context
          scope.page.render({
            canvasContext: context,
            viewport: scope.scaledViewport
          });

          scope.deveRenderizar = false;
        }

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
