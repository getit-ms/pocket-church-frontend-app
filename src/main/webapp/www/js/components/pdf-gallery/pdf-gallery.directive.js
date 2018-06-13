calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            arquivo:'=pdf'
        },
        templateUrl: 'js/components/pdf-gallery/pdf-gallery.html',
        controller: ['$scope', 'arquivoService', function($scope, arquivoService){

          $scope.load = function() {
            arquivoService.get($scope.arquivo.id, function(loaded) {

              if (loaded.success) {
                PDFJS.getDocument(loaded.file).promise.then(function(pdf) {
                  $scope.pdf = pdf;
                  $scope.pages = [];
                  for (var i=1;i<=pdf.numPages;i++) {
                    $scope.pages.push(i);
                  }

                  $scope.buscaProxima();
                });
              }

            });

          };

          $scope.buscaProxima = function (anterior) {
            var proxima = (anterior || 0)+1;
            if (proxima <= $scope.pdf.numPages) {
              $scope.buscaPagina(proxima, function() {
                $scope.buscaProxima(proxima);
              });
            }
          };

          $scope.buscaPagina = function(nr, callback) {
            $scope.pdf.getPage(nr).then(function(page) {

              var canvas = document.getElementById('page-canvas-' + ri);

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
