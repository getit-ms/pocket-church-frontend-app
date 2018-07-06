calvinApp.directive('calvinPagination', function(){
    return {
        restrict: 'E',
        transclude: true,
        scope:{
            ngModel: '=',
            cache: '@',
            searcher: '=',
            notFoundMessage: '=?'
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
                        if (data && data.resultados) {
                          angular.forEach(data.resultados, function(d){
                              $scope.ngModel.push(d);
                          });
                        }

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
                        cacheService.get({
                            chave:$scope.cache,
                            callback: function(data){
                                $scope.ngModel = data;
                            },
                            supplier: function(callback){
                                $scope.search(1, function(data){
                                    callback(data.resultados);
                                });
                            }
                        });
                    }else{
                        $scope.search(1, function(data){
                            $scope.ngModel = data.resultados;
                        });
                    }
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
