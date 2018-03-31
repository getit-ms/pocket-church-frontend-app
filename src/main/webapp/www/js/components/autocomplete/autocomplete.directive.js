calvinApp.directive('autocomplete', function(){
  return {
    scope: {
      autocomplete: '='
    },
    restrict: "A",
    link: function(scope, element, attrs, ctrl, transclude) {

      new autoComplete(angular.extend(
        {},
        scope.autocomplete || {},
        {
          selector: element[0]
        }
      ));

    },
    controller: ['$scope', '$compile', function($scope, $compile) {



    }]
  };
});
