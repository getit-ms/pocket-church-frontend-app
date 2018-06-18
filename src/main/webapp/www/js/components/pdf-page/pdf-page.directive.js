calvinApp.directive('pdfPage', function(){
  return {
    restrict: 'E',
    scope:{
      tipo:'@',
      id:'=',
      page:'=',
      renderLazy:'='
    },
    templateUrl: 'js/components/pdf-page/pdf-page.html',
    controller: ['$scope', 'pdfService', function($scope, pdfService) {
      $scope.pdfService = pdfService;
    }],
    link: function(scope, element, attrs, ctrl, transclude) {

      element[0].style.display = 'block';
      element[0].style.width = '100%';

      scope.load = function() {
        if (!scope.page || !scope.pdfService) return;

        var viewport = scope.page.getViewport(1);
        var desiredWidth = element[0].getBoundingClientRect().width;
        var scale = desiredWidth / viewport.width;
        var scaledViewport = scope.page.getViewport(scale);

        var currentViewport = scope.page.getViewport(element[0].offsetWidth / viewport.width);

        element[0].children[0].style.height = Math.round(currentViewport.height) + 'px';
        element[0].children[0].style.width = Math.round(currentViewport.width) + 'px';

        scope.deveRenderizar = true;
        scope.scale = scale;
        scope.currentViewport = currentViewport;
        scope.scaledViewport = scaledViewport;
        scope.renderiza(scope.inview);
      };

      scope.renderiza = function(inview) {
        scope.inview = inview;

        if ((!scope.renderLazy || scope.inview) && scope.deveRenderizar) {
          clearTimeout(scope.rendering);

          scope.rendering = setTimeout(function() {
            scope.pdfService.getPage(scope.tipo, scope.id, scope.page, scope.scale, function(path) {

              element[0].children[0].classList.remove('loading');
              element[0].children[0].style.backgroundImage = 'url(' + path + ')';

              scope.deveRenderizar = false;
            }, function(err) {

              element[0].children[0].classList.remove('loading');
              element[0].children[0].style.backgroundImage = 'url(img/fail.png)';

              console.error(err);

              scope.deveRenderizar = false;
            });

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
