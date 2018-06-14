calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            arquivo:'=pdf'
        },
        templateUrl: 'js/components/pdf-viewer/pdf-viewer.html',
        controller: ['$scope', 'pdfService', function($scope, pdfService){

          $scope.load = function() {
            pdfService.get($scope.arquivo.id, function(pdf) {
              $scope.pdf = pdf;
            });
          };

          $scope.buscaPagina = function(nr, callback, ri) {
            $scope.pdf.getPage(nr).then(function(page) {
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
