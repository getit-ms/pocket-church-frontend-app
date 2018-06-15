calvinApp.directive('pdfPage', function(){
  return {
    restrict: 'E',
    scope:{
      page:'=',
      renderLazy:'='
    },
    templateUrl: 'js/components/pdf-page/pdf-page.html',
    link: function(scope, element, attrs, ctrl, transclude) {

      scope.load = function() {
        if (!scope.page) return;

        var canvas = element[0].children[0];

        var viewport = scope.page.getViewport(1);
        var desiredWidth = canvas.getBoundingClientRect().width;
        var scale = desiredWidth / viewport.width;
        var scaledViewport = scope.page.getViewport(scale);

        // Prepare canvas using PDF page dimensions
        canvas.height = scaledViewport.height;
        canvas.width = scaledViewport.width;

        scope.deveRenderizar = true;
        scope.scaledViewport = scaledViewport;
        scope.renderiza(scope.inview);
      };

      scope.renderiza = function(inview) {
        scope.inview = inview;

        if ((!scope.renderLazy || scope.inview) && scope.deveRenderizar) {
          clearTimeout(scope.rendering);

          scope.rendering = setTimeout(function() {
            var canvas = element[0].children[0];

            var context = canvas.getContext('2d');

            context.clearRect(0, 0, canvas.width, canvas.height);

            // Render PDF page into canvas context
            scope.page.render({
              canvasContext: context,
              viewport: scope.scaledViewport
            });

            scope.deveRenderizar = false;
          }, 300);
        }

      };

      scope.$watch(function() {
        return element[0].children[0].getBoundingClientRect().width;
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
