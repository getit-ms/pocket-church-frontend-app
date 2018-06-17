calvinApp.directive('pdfViewer', function(){
  return {
    restrict: 'E',
    scope:{
      arquivo:'=pdf',
      status:'='
    },
    templateUrl: 'js/components/pdf-viewer/pdf-viewer.html',
    controller: ['$scope', 'pdfService', '$ionicScrollDelegate',
      function($scope, pdfService, $ionicScrollDelegate){

        $scope.load = function() {
          pdfService.get($scope.arquivo.id, function(pdf) {
            $scope.pdf = pdf;

            initSlide();

            $scope.$apply();
          });
        };

        $scope.supplier = function(nr, callback) {
          $scope.pdf.getPage(Number(nr)).then(function(page) {
            callback({page: page});
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
            $scope.slider.unlockSwipes();
            $scope.slider.params.onlyExternal = false;
            $scope.slider.params.allowClick = true;
          } else {
            $scope.slider.lockSwipes();
            $scope.slider.params.onlyExternal = true;
          }
        };

        function initSlide() {

          var makeSlide = function ( nr ) {
            var dados = {nr : nr};
            if ($scope.showSlide(dados)) {
              $scope.supplier(nr, function(d0){
                angular.extend(dados, d0);
                $scope.$apply();
              });
            }
            return dados;
          };

          $scope.slideShow = {first: 1, last: $scope.pdf.numPages};

          $scope.showSlide = function (slide) {
            return (slide.nr >= $scope.slideShow.first && slide.nr <= $scope.slideShow.last);
          };

          if (!$scope.status) {
            $scope.status = {pagina:1, total:$scope.pdf.numPages};
          } else {
            $scope.status.total = $scope.pdf.numPages;

            if (!$scope.status.pagina) { // initial
              $scope.status.pagina = 1;
            } else {
              $scope.status.pagina = Number($scope.status.pagina);
            }
          }

          $scope.status.hasAnterior = function() {
            return $scope.slides[i].nr != $scope.slideShow.first;
          };

          $scope.status.hasProximo = function() {
            return $scope.slides[i].nr != $scope.slideShow.last;
          };

          $scope.slides = [
            makeSlide($scope.status.pagina),
            makeSlide($scope.status.pagina + 1),
            makeSlide($scope.status.pagina + 2),
            makeSlide($scope.status.pagina - 2),
            makeSlide($scope.status.pagina - 1)
          ];

          if (!$scope.status.hasAnterior()){
            $scope.slider.lockSwipeToPrev();
          } else if (!$scope.status.hasProximo()) {
            $scope.slider.unlockSwipeToNext();
          }

          $scope.$on('$ionicSlides.sliderInitialized', function(event, data) {
            $scope.slider = data.slider;

            $scope.status.proximo = function() {
              $scope.slider.swipeRight();
            };

            $scope.status.anterior = function() {
              $scope.slider.swipeLeft();
            };

            $scope.$watch('slider.activeIndex', function() {
              var
                i = ($scope.slider.activeIndex % $scope.slides.length),
                previous_index = ($scope.slides.length + i - 2) % $scope.slides.length,
                direction = $scope.slides[i].nr > $scope.slides[previous_index].nr  ? 2 : -2;

              if (i == $scope.lastIndex) return;

              $scope.lastIndex = i;

              var nrProx = $scope.slides[i].nr + direction;
              var idxProx = ($scope.slides.length + i + direction) % $scope.slides.length;

              if ($scope.slides[idxProx].nr != nrProx) {
                $scope.slides[idxProx] = makeSlide(nrProx);
              }

              if (!$scope.status.hasAnterior()){
                $scope.slider.lockSwipeToPrev();
              } else if (!$scope.status.hasProximo()) {
                $scope.slider.unlockSwipeToNext();
              } else {
                $scope.slider.unlockSwipes();
              }
            });

          });
        }

      }]
  };
});
