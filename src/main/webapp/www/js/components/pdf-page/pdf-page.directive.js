calvinApp.directive('pdfPage', function(){
  return {
    restrict: 'E',
    scope:{
      page:'=',
      renderLazy:'='
    },
    templateUrl: 'js/components/pdf-page/pdf-page.html',
    link: function(scope, element, attrs, ctrl, transclude) {

      element[0].style.display = 'block';
      element[0].style.width = '100%';

      scope.load = function() {
        if (!scope.page) return;

        var viewport = scope.page.getViewport(1);
        var desiredWidth = element[0].getBoundingClientRect().width;
        var scale = desiredWidth / viewport.width;
        var scaledViewport = scope.page.getViewport(scale);

        var currentViewport = scope.page.getViewport(element[0].offsetWidth / viewport.width);

        element[0].children[0].style.height = Math.round(currentViewport.height) + 'px';
        element[0].children[0].style.width = Math.round(currentViewport.width) + 'px';

        scope.deveRenderizar = true;
        scope.currentViewport = currentViewport;
        scope.scaledViewport = scaledViewport;
        scope.renderiza(scope.inview);
      };

      scope.renderiza = function(inview) {
        scope.inview = inview;

        if ((!scope.renderLazy || scope.inview) && scope.deveRenderizar) {
          clearTimeout(scope.rendering);

          scope.rendering = setTimeout(function() {
            var canvas = document.createElement('canvas');

            // Prepare canvas using PDF page dimensions
            canvas.height = scope.scaledViewport.height;
            canvas.width = scope.scaledViewport.width;

            canvas.style.height = Math.round(scope.currentViewport.height) + 'px';
            canvas.style.width = Math.round(scope.currentViewport.width) + 'px';

            var context = canvas.getContext('2d');

            // Render PDF page into canvas context
            scope.page.render({
              canvasContext: context,
              viewport: scope.scaledViewport
            }).then(function() {
              element[0].removeChild(element[0].children[0]);
              element[0].appendChild(canvas);
            });

            scope.deveRenderizar = false;
          }, 300);
        }

      };

      scope.$watch(function() {
        return element[0].getBoundingClientRect().width;
      }, function() {
        scope.load();
      });

      scope.$watch('page', function() {
        if (scope.page != scope.lastPage) {
          scope.lastPage = scope.page;

          scope.load();
        }
      });

      scope.load();
    }
  };
});
