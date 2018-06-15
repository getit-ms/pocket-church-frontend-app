calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        scope:{
            arquivo:'=pdf',
            initialSlide:'='
        },
        templateUrl: 'js/components/pdf-viewer/pdf-viewer.html',
        controller: ['$scope', 'pdfService', '$ionicSlideBoxDelegate', '$ionicScrollDelegate',
          function($scope, pdfService, $ionicSlideBoxDelegate, $ionicScrollDelegate){

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
                } else {
                  $scope.$apply();
                }
              };

              buscaPagina(1);

              $scope.$apply();
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

          $scope.updateSlideStatus = function(index) {
            var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
            if (zoomFactor == 1) {
              $ionicSlideBoxDelegate.enableSlide(true);
            } else {
              $ionicSlideBoxDelegate.enableSlide(false);
            }
          };

        }]
    };
});
