calvinApp.directive('autocomplete', function(){
  return {
    scope: {
      autocomplete: '=',
      ngModel: '='
    },
    restrict: "A",
    link: function(scope, element, attrs, ctrl, transclude) {

      element.bind('keyup', function($event){
        scope.search($event);
      });

      element.bind('keydown', function($event){
        scope.search($event);
      });

    },
    controller: ['$scope', '$ionicPopover', function($scope, $ionicPopover) {

      var template;
      if ($scope.autocomplete && $scope.autocomplete.template) {
        template = $scope.autocomplete.template;
      } else {
        template = '<ion-popover-view class="autocomplete"><ion-content><div ng-click="onSelect(item)" ng-repeat="item in items" ng-bind-html="renderItem(item)" ></div></ion-content></ion-popover-view>';
      }

      $scope.ac = $ionicPopover
        .fromTemplate(template, {
          scope: $scope
        });

      $scope.onSelect = function(item) {
        if ($scope.autocomplete.onSelect) {
          $scope.autocomplete.onSelect(item);
        }

        $scope.ac.hide();
      };

      $scope.renderItem = function(item) {
        if ($scope.autocomplete.renderItem) {
          return $scope.autocomplete.renderItem(item);
        }

        return item;
      };

      $scope.search = function($event) {
        clearTimeout($scope.call);

        $scope.call = setTimeout(function() {
          if ($scope.ngModel && String($scope.ngModel).length >= ($scope.autocomplete.minChars || 3)) {
            $scope.autocomplete.source($scope.ngModel, function(items) {
              $scope.items = items;

              if ($scope.items.length) {
                if (!$scope.ac.isShown()) {
                  $scope.ac.show($event);
                }
              } else {
                if ($scope.ac.isShown()) {
                  $scope.ac.hide();
                }
              }
            });
          } else {
            $scope.ac.hide();
          }
        }, 150);
      };

      $scope.$on('$destroy', function() {
        $scope.ac.remove();
      });

    }]
  };
});

