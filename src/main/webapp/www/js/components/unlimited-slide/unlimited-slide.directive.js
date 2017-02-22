calvinApp.directive('unlimitedSlide', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            first:'@',
            last:'@',
            supplier:'='
        },
        link: function(scope, element, attrs, ctrl, transclude) {
          transclude(scope.$parent, function(clone, scope) {
            element.append(clone);
          });
        },
        templateUrl: 'js/components/unlimited-slide/unlimited-slide.html',
        controller: ['$scope', '$ionicSlideBoxDelegate', function($scope, $ionicSlideBoxDelegate){
                $scope.slideShow={
                    first:$scope.first,
                    last:$scope.last
                };
                
                var makeSlide = function ( nr ) {
                    var dados = {nr : nr};
                    $scope.supplier(nr, function(d0){
                        angular.extend(dados, d0);
                    });
                    return dados;
                };
                
                var
                default_slides_indexes = [ -1, 0, 1 ],
                default_slides = [
                    makeSlide( default_slides_indexes[ 0 ] ),
                    makeSlide( default_slides_indexes[ 1 ] ),
                    makeSlide( default_slides_indexes[ 2 ] )
                ];
                $scope.slides = [
                    default_slides[ 0 ],
                    default_slides[ 1 ],
                    default_slides[ 2 ]
                ];
                $scope.selectedSlide = 1; // initial
                
                $scope.showDefaultSlides = function () {
                    var
                    i              = $ionicSlideBoxDelegate.currentIndex(),
                    previous_index = i === 0 ? 2 : i - 1,
                    next_index     = i === 2 ? 0 : i + 1;
                    
                    $scope.slides[ i ] = default_slides[ 1 ];
                    $scope.slides[ previous_index ] = default_slides[ 0 ];
                    $scope.slides[ next_index ] = default_slides[ 2 ];
                    direction = 0;
                    head      = $scope.slides[ previous_index ].nr;
                    tail      = $scope.slides[ next_index ].nr;
                };
                
                var direction = 0;
                
                $scope.slideChanged = function ( i ) {
                    var
                    previous_index = i === 0 ? 2 : i - 1,
                    next_index     = i === 2 ? 0 : i + 1,
                    new_direction  = $scope.slides[ i ].nr > $scope.slides[ previous_index ].nr ? 1 : -1;
                    
                    $scope.slides[ new_direction > 0 ? next_index : previous_index ] = 
                            createSlideData( new_direction, direction );
                    
                    direction = new_direction;
                    
                    if($scope.slides[i].nr===($scope.slideShow.first-1)||
                            $scope.slides[i].nr===($scope.slideShow.last+1)){
                        
			var nrTmp=(direction>0)?$scope.slideShow.last:$scope.slideShow.first;
                        
                        var iTmp = getIfromNr(nrTmp);
                        
                        if(iTmp>-1){
                            $ionicSlideBoxDelegate.$getByHandle('slideshow-slidebox').slide(iTmp);
                        }
                    }
                    
                };
                
                var
                head = $scope.slides[ 0 ].nr,
                tail = $scope.slides[ $scope.slides.length - 1 ].nr;
                
                var createSlideData = function ( new_direction, old_direction ) {
                    var nr;
                    
                    if ( new_direction === 1 ) {
                        tail = old_direction < 0 ? head + 3 : tail + 1;  
                    }
                    else {
                        head = old_direction > 0 ? tail - 3 : head - 1;
                    }
                    
                    nr = new_direction === 1 ? tail : head;
                    if ( default_slides_indexes.indexOf( nr ) !== -1 ) {
                        return default_slides[ default_slides_indexes.indexOf( nr ) ];
                    };
                    
                    return makeSlide( nr );
                };
                
                $scope.showSlide = function(slide){
                    return (slide.nr>=$scope.slideShow.first && slide.nr<=$scope.slideShow.last);
                };
                
                var getIfromNr = function(nr){
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
                
            }]
    };
});