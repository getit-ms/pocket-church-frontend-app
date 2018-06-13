calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            arquivo:'=pdf'
        },
        templateUrl: 'js/components/pdf-viewer/pdf-viewer.html',
        controller: ['$scope', 'arquivoService', function($scope, arquivoService){

          $scope.load = function() {
            arquivoService.get($scope.arquivo.id, function(loaded) {

              if (loaded.success) {
                PDFJS.getDocument(loaded.file).promise.then(function(pdf) {
                  $scope.pdf = pdf;
                });
              }

            });

          };

          $scope.buscaPagina = function(nr, callback, ri) {
            $scope.pdf.getPage(nr).then(function(page) {

              var canvas = document.getElementById('pdf-canvas-' + ri);

              var desiredWidth = canvas.offsetWidth;
              var viewport = page.getViewport(1);
              var scale = desiredWidth / viewport.width;
              var scaledViewport = page.getViewport(scale);

              // Prepare canvas using PDF page dimensions
              var context = canvas.getContext('2d');
              canvas.height = scaledViewport.height;

              // Render PDF page into canvas context
              var renderContext = {
                canvasContext: context,
                viewport: scaledViewport
              };

              callback({page: page});
            });
          };

          if ($scope.arquivo && $scope.arquivo.id) {
            $scope.load();
          } else {
            var stop = $scope.$watch('arquivo.id', function() {
              if ($scope.arquivo && $scope.arquivo.id) {
                stop();

                $scope.load();
              }
            });
          }

        }]
    };
});
