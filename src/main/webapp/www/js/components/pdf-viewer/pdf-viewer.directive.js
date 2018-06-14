calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        scope:{
            arquivo:'=pdf'
        },
        templateUrl: 'js/components/pdf-viewer/pdf-viewer.html',
        controller: ['$scope', 'pdfService', function($scope, pdfService){

          $scope.load = function() {
            pdfService.get($scope.arquivo.id, function(pdf) {
              $scope.pdf = pdf;
              $scope.$apply();
            });
          };

          $scope.buscaPagina = function(nr, callback, ri) {
            if (nr >= 1 && nr <= $scope.pdf.numPages) {
              $scope.pdf.getPage(nr).then(function(page) {
                callback({page: page});
                $scope.$apply();
              });
            }
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
