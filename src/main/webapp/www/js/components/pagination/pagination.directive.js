calvinApp.directive('calvinPagination', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            ngModel: '=',
            cache: '@',
            searcher: '=',
            notFoundMessage: '='
        },
        templateUrl: 'js/components/pagination/pagination.html',
        controller: ['$scope', 'cacheService', function($scope, cacheService){
                if ($scope.notFoundMessage === undefined){
                    $scope.notFoundMessage = true;
                }
                
                $scope.refresh = function(){
                    $scope.page = 0;
                    $scope.ngModel = [];
                    $scope.hasMore = false;
                    
                    $scope.more();
                };
                
                $scope.more = function(){
                    $scope.page++;
                    $scope.search($scope.page, function(data){
                        data.resultados.forEach(function(d){
                            $scope.ngModel.push(d);    
                        });
                        $scope.$broadcast('scroll.infiniteScrollComplete');
                    });
                };
                
                $scope.search = function(page, callback){
                    $scope.page = page;
                    $scope.searcher(page, function(data){
                        callback(data);
                        $scope.hasMore = data.hasProxima;
                        $scope.$broadcast('scroll.refreshComplete');
                    }, function(){
                        $scope.$broadcast('scroll.refreshComplete');
                    });
                };
                
                $scope.init = function(){
                    if ($scope.cache){
                        $scope.ngModel = cacheService.load()[$scope.cache];
                    }
                    
                    $scope.search(1, function(data){
                        $scope.ngModel = data.resultados;
                        
                        if ($scope.cache){				
                            var cache = {};
                            cache[$scope.cache] = $scope.ngModel;
                            cacheService.save(cache);
                        }
                    });
                };
                
                $scope.$on('pagination.search', function() {
                    $scope.init();
                });
                
                $scope.$on('pagination.refresh', function() {
                    $scope.refresh();
                });
                
                $scope.$on('pagination.more', function() {
                    $scope.more();
                });
                
                $scope.init();
            }]
    };
});