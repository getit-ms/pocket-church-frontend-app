calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        scope:{
            arquivo:'=pdf'
        },
        templateUrl: 'js/components/pdf-viewer/pdf-viewer.html',
        controller: ['$scope', 'pdfService', '$ionicSlideBoxDelegate', function($scope, pdfService, $ionicSlideBoxDelegate){

          $scope.load = function() {
            pdfService.get($scope.arquivo.id, function(pdf) {
              $scope.pdf = pdf;

              initSlide();

              $scope.$apply();
            });
          };

          $scope.supplier = function(nr, callback) {
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

          function initSlide() {
            var makeSlide = function ( nr, ri ) {
              var dados = {nr : nr};
              $scope.supplier(nr, function(d0){
                angular.extend(dados, d0);
              });
              return dados;
            };

            $scope.slideShow = {first: 1, last: $scope.pdf.numPages};

            var
              default_slides_indexes = [-1, 0, 1],
              default_slides = [
                makeSlide(default_slides_indexes[0], 0),
                makeSlide(default_slides_indexes[1], 1),
                makeSlide(default_slides_indexes[2], 2)
              ];

            $scope.slides = [
              default_slides[0],
              default_slides[1],
              default_slides[2]
            ];

            if (!$scope.selectedSlide) {
              $scope.selectedSlide = 1; // initial
            }

            $scope.showDefaultSlides = function () {
              var
                i = $ionicSlideBoxDelegate.currentIndex(),
                previous_index = i === 0 ? 2 : i - 1,
                next_index = i === 2 ? 0 : i + 1;

              $scope.slides[i] = default_slides[1];
              $scope.slides[previous_index] = default_slides[0];
              $scope.slides[next_index] = default_slides[2];
              direction = 0;
              head = $scope.slides[previous_index].nr;
              tail = $scope.slides[next_index].nr;
            };

            var direction = 0;

            $scope.slideChanged = function (i) {
              var
                previous_index = i === 0 ? 2 : i - 1,
                next_index = i === 2 ? 0 : i + 1,
                new_direction = $scope.slides[i].nr > $scope.slides[previous_index].nr ? 1 : -1;

              var ri = new_direction > 0 ? next_index : previous_index;
              $scope.slides[ri] = createSlideData(new_direction, direction, ri);

              direction = new_direction;

              if ($scope.slides[i].nr === ($scope.slideShow.first - 1) ||
                $scope.slides[i].nr === ($scope.slideShow.last + 1)) {

                var nrTmp = (direction > 0) ? $scope.slideShow.last : $scope.slideShow.first;

                var iTmp = getIfromNr(nrTmp);

                if (iTmp > -1) {
                  $ionicSlideBoxDelegate.$getByHandle('slideshow-slidebox').slide(iTmp);
                }
              }

            };

            var
              head = $scope.slides[0].nr,
              tail = $scope.slides[$scope.slides.length - 1].nr;

            var createSlideData = function (new_direction, old_direction, ri) {
              var nr;

              if (new_direction === 1) {
                tail = old_direction < 0 ? head + 3 : tail + 1;
              }
              else {
                head = old_direction > 0 ? tail - 3 : head - 1;
              }

              nr = new_direction === 1 ? tail : head;
              if (default_slides_indexes.indexOf(nr) !== -1) {
                return default_slides[default_slides_indexes.indexOf(nr)];
              }
              ;

              return makeSlide(nr, ri);
            };

            $scope.showSlide = function (slide) {
              return (slide.nr >= $scope.slideShow.first && slide.nr <= $scope.slideShow.last);
            };

            var getIfromNr = function (nr) {
              try {
                for (var i = 0; i < $scope.slides.length; i++) {
                  if ($scope.slides[i].nr == nr) {
                    return i;
                  }
                }
              } catch (e) {
              }
              return -1;
            };
          }

        }]
    };
});
