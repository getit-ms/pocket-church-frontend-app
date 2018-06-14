calvinApp.directive('pdfPage', function(){
    return {
        restrict: 'A',
        scope:{
            page:'=pdfPage'
        },
        link: function(scope, element, attrs, ctrl, transclude) {

          scope.load = function() {
            scope.lastPage = scope.page;

            var canvas = element;

            var desiredWidth = canvas.offsetWidth;
            var viewport = scope.page.getViewport(1);
            var scale = desiredWidth / viewport.width;
            var scaledViewport = scope.page.getViewport(scale);

            // Prepare canvas using PDF page dimensions
            var context = canvas.getContext('2d');
            canvas.height = scaledViewport.height;

            // Render PDF page into canvas context
            var renderContext = {
              canvasContext: context,
              viewport: scaledViewport
            };
          };

          if (scope.page) {
            scope.load();
          }

          scope.$watch('page', function() {
            if (scope.page && scope.lastPage != scope.page) {
              scope.load();
            }
          });

        }
    };
});
