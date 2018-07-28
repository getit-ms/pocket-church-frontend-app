calvinApp.directive('galleryViewer', function(){
  return {
    restrict: 'E',
    scope:{
      total:'=',
      supplier: '=',
      status:'='
    },
    templateUrl: 'js/components/gallery-viewer/gallery-viewer.html',
    controller: ['$scope', '$ionicScrollDelegate', function($scope, $ionicScrollDelegate){

      function lockPadroes() {
        $scope.slider.unlockSwipes();

        if (!$scope.status.hasAnterior()){
          $scope.slider.lockSwipeToPrev();
        }

        if (!$scope.status.hasProximo()) {
          $scope.slider.lockSwipeToNext();
        }
      }

      $scope.updateSlideStatus = function(index) {
        var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
        if (zoomFactor == 1) {
          lockPadroes();

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

        $scope.slideShow = {first: 1, last: $scope.total};

        $scope.showSlide = function (slide) {
          return (slide.nr >= $scope.slideShow.first && slide.nr <= $scope.slideShow.last);
        };

        if (!$scope.status) {
          $scope.status = {pagina:1, total:$scope.total};
        } else {
          $scope.status.total = $scope.total;

          if (!$scope.status.pagina) { // initial
            $scope.status.pagina = 1;
          } else {
            $scope.status.pagina = Number($scope.status.pagina);
          }
        }

        $scope.slides = [
          makeSlide($scope.status.pagina),
          makeSlide($scope.status.pagina + 1),
          makeSlide($scope.status.pagina + 2),
          makeSlide($scope.status.pagina - 2),
          makeSlide($scope.status.pagina - 1)
        ];

        function cachePaginas() {
          var
            i = ((500000 + $scope.slider.activeIndex - 1) % $scope.slides.length),
            previous_index = (500000 + i - 2) % $scope.slides.length,
            direction = $scope.slides[i].nr > $scope.slides[previous_index].nr  ? 2 : -2;

          if (i == $scope.lastIndex) return;

          $scope.lastIndex = i;

          $scope.status.pagina = $scope.slides[i].nr;

          var nrProx = $scope.slides[i].nr + direction;
          var idxProx = ($scope.slides.length + i + direction) % $scope.slides.length;

          if ($scope.slides[idxProx].nr != nrProx) {
            $scope.slides[idxProx] = makeSlide(nrProx);
          }

          lockPadroes();
        };

        $scope.clearTap = function() {
          clearTimeout($scope.tap);
          $scope.tap = undefined;
        };

        $scope.actionClick = function() {

          if (!$scope.tap) {
            $scope.tap = setTimeout(function() {
              $scope.clearTap();

              if ($scope.status.click) {
                $scope.status.click();
              }

              $scope.$apply();
            }, 300);
          } else {
            $scope.clearTap();

            var index = ($scope.slider.activeIndex - 1);

            var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
            if (zoomFactor == 1) {
              $ionicScrollDelegate.$getByHandle('scrollHandle' + index).zoomTo(2, true);
            } else {
              $ionicScrollDelegate.$getByHandle('scrollHandle' + index).zoomTo(1, true);
            }

            setTimeout(function() {
              $scope.$apply();
            }, 100);
          }
        };

        $scope.status.hasAnterior = function() {
          return $scope.slider && !$scope.slider.params.onlyExternal &&
            $scope.slides[(500000 + $scope.slider.activeIndex - 1) % $scope.slides.length].nr > $scope.slideShow.first;
        };

        $scope.status.hasProximo = function() {
          return $scope.slider && !$scope.slider.params.onlyExternal &&
            $scope.slides[(500000 + $scope.slider.activeIndex - 1) % $scope.slides.length].nr < $scope.slideShow.last;
        };

        $scope.$on('$ionicSlides.sliderInitialized', function(event, data) {
          $scope.slider = data.slider;

          lockPadroes();

          $scope.status.proximo = function() {
            if ($scope.status.hasProximo()) {
              $scope.slider.slideNext();
              cachePaginas();
            }
          };

          $scope.status.anterior = function() {
            if ($scope.status.hasAnterior()) {
              $scope.slider.slidePrev();
              cachePaginas();
            }
          };

          $scope.$watch('slider.activeIndex', cachePaginas);

        });
      }

      initSlide();
    }]
  };
});