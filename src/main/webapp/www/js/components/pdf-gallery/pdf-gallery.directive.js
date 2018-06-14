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
              for (var i=1;i<=pdf.numPages;i++) {
                pdf.getPage(nr).then(function(page) {
                  $scope.pages.push(page);
                });
              }
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
