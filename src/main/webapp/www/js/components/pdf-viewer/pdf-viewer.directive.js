calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        scope:{
            arquivo:'=pdf',
            initialSlide:'='
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
            } else {
              $scope.slider.lockSwipes();
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

            if (!$scope.initialSlide) { // initial
              $scope.initialSlide = 1;
            } else {
              $scope.initialSlide = Number($scope.initialSlide);
            }

            $scope.slides = [
              makeSlide($scope.initialSlide),
              makeSlide($scope.initialSlide + 1),
              makeSlide($scope.initialSlide + 2),
              makeSlide($scope.initialSlide - 2),
              makeSlide($scope.initialSlide - 1)
            ];

            console.log('Iniciado com nrs ' + $scope.slides[0].nr  + ', ' + $scope.slides[1].nr + ', ' + $scope.slides[2].nr);

            $scope.$on('$ionicSlides.sliderInitialized', function(event, data) {
              $scope.slider = data.slider;

              $scope.$watch('slider.activeIndex', function() {
                var
                  i = ($scope.slider.activeIndex % $scope.slides.length),
                  previous_index = ($scope.slides.length + i - 2) % $scope.slides.length,
                  direction = $scope.slides[i].nr > $scope.slides[previous_index].nr  ? 2 : -2;

                if (i == $scope.lastIndex) return;

                $scope.lastIndex = i;

                console.log('Carregando idx ' + i + ' nr ' + $scope.slides[i].nr);

                var nrProx = $scope.slides[i].nr + direction;
                var idxProx = ($scope.slides.length + i + direction) % $scope.slides.length;

                console.log('Preparando idx ' + idxProx + ' nr ' + nrProx);

                if ($scope.slides[idxProx].nr != nrProx) {
                  $scope.slides[idxProx] = makeSlide(nrProx);
                }

                if ($scope.slides[i].nr < $scope.slideShow.first || $scope.slides[i].nr > $scope.slideShow.last) {
                  console.log('Redirecionando para idx ' + i - direction);

                  $scope.slider.slideTo(i - direction);
                }
              });

            });
          }

        }]
    };
});
