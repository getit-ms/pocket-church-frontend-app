calvinApp.directive('pdfGallery', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            arquivo:'=pdf'
        },
        templateUrl: 'js/components/pdf-gallery/pdf-gallery.html',
        controller: ['$scope', 'pdfService', function($scope, pdfService){

          $scope.load = function() {
            pdfService.get($scope.arquivo.id, function(pdf) {
              $scope.pdf = pdf;
              $scope.pages = [];

              var buscaPagina = function(i) {
                if (i<=pdf.numPages) {
                  pdf.getPage(i).then(function(page) {
                    $scope.pages.push(page);

                    buscaPagina(i + 1);
                  }, function(err) {
                    console.error(err);
                  });
                }
              };

              buscaPagina(1);
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
