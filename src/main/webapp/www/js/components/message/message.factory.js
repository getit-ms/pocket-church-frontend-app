calvinApp.factory('message', ['$ionicPopup', '$filter', '$rootScope', function($ionicPopup, $filter, $rootScope){
    return function(alert){
        if (!$rootScope.popupShown){
            $rootScope.popupShown = true;

            return $ionicPopup.alert({
                title: $filter('translate')(alert.title),
                template: $filter('translate')(alert.template)
            }).then(function(){
                $rootScope.popupShown = false;
            });
        }
    };
}]).factory('backendErrors', ['$rootScope', function($rootScope){
    return {
        args: function(name){
            return $rootScope['bckend.args.' + name];
        },
        get: function(name){
            return $rootScope['bckend.error.' + name];
        },
        set: function(name, value, args){
            $rootScope['bckend.error.' + name] = value;
            $rootScope['bckend.args.' + name] = args;
        },
        contains: function(name){
            var value = this.get(name);
            return value && value != '';
        },
        watch: function(name, func){
            $rootScope.$watch(function(){
                    return $rootScope['bckend.error.' + name];
            }, func);
        }
    };
}]);