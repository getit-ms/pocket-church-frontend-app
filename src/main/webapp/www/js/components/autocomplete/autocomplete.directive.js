calvinApp.directive('autocomplete', function(){
  return {
    scope: {
      autocomplete: '='
    },
    restrict: "A",
    link: function(scope, element, attrs, ctrl, transclude) {

      scope.ac = new autoComplete(angular.extend(
        {},
        scope.autocomplete || {},
        {
          selector: element[0]
        }
      ));

    },
    controller: ['$scope', '$compile', function($scope, $compile) {

      $scope.$on('$destroy', function() {
        $scope.ac.destroy();
      })

    }]
  };
});
