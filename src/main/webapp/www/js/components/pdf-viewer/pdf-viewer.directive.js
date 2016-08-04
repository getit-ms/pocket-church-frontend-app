calvinApp.directive('pdfViewer', function(){
    return {
        restrict: 'E',
        scope:{
            path: '@'
        },
        templateUrl: 'js/components/pdf-viewer/pdf-viewer.html',
        controller: ['$scope', 'configService', '$http', '$window', function($scope, configService, $http, $window){
            $scope.httpHeaders = {};
            
            var config = configService.load();
            
            angular.extend($scope.httpHeaders, config.headers);
            
            $scope.pdfUrl = config.server + $scope.path;

            $scope.$watch('path', function(){
                $scope.pdfUrl = config.server + $scope.path;
            });
                
            var stop = $scope.$watch('pageCount', function(){
                if ($scope.pageCount){
                    $scope.fit();
                    stop();
                }
            });

            $scope.salvar = function(){
                $http({
                    method: 'GET',
                    url: $scope.pdfUrl,
                    headers: $scope.httpHeaders
                }).then(function(response){
                    $window.open('data:application/force-download,' + escape(response.data));
                });
            };
        }]
    };
});