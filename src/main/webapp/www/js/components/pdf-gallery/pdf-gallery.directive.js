calvinApp.directive('pdfGallery', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            tipo: '@',
            arquivo:'=pdf',
            titulo:'@'
        },
        templateUrl: 'js/components/pdf-gallery/pdf-gallery.html',
        controller: ['$scope', 'pdfService', '$ionicModal', 'loadingService', 'message', function($scope, pdfService, $ionicModal, loadingService, message){

          $scope.load = function() {
            loadingService.show();

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

              loadingService.hide();
            }, function() {
              loadingService.hide();

              message({title:'global.title.500',template:'mensagens.MSG-500',args:{mensagem:ex.message}});
            });
          };

          $scope.openModal = function (page) {
            $scope.status = {pagina: page.pageIndex + 1,click:function() {
              $scope.barsHidden = !$scope.barsHidden;
            }};
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
