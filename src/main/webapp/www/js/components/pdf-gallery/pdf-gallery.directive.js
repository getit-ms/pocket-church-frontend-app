calvinApp.directive('pdfGallery', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            arquivo:'=pdf',
            titulo:'@'
        },
        templateUrl: 'js/components/pdf-gallery/pdf-gallery.html',
        controller: ['$scope', 'pdfService', '$ionicModal', function($scope, pdfService, $ionicModal){

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
            });
          };

          $scope.toggleBarsHidden = function() {
            $scope.barsHidden = !$scope.barsHidden;
          };

          $scope.openModal = function (page) {
            $scope.status = {pagina: page.pageIndex + 1};
            $scope.barsHidden = true;

            $ionicModal.fromTemplateUrl('js/components/pdf-gallery/pdf-gallery.modal.html', {
              scope: $scope,
              animation: 'slide-in-up'
            }).then(function(modal) {
              $scope.modal = modal;
              $scope.modal.show();
            });
          };

          $scope.$on('modal.hidden', function() {
            $scope.closeModal();
          });

          $scope.$on('$ionicView.leave', function() {
            $scope.closeModal();
          });

          $scope.closeModal = function() {
            if ($scope.modal){
              var modal = $scope.modal;

              $scope.modal = undefined;

              modal.hide();
              modal.remove();
            }
          };

          if ($scope.arquivo && $scope.arquivo.id) {
            $scope.load();
          } else {
            var stop = $scope.$watch(function() {
              return $scope.arquivo && $scope.arquivo.id;
            }, function() {
              if ($scope.arquivo && $scope.arquivo.id) {
                stop();

                $scope.load();
              }
            });
          }

        }]
    };
});
