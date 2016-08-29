calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('institucional', {
        parent: 'site',
        url: '/institucional',
        views:{
            'content@':{
                templateUrl: 'js/institucional/institucional.form.html',
                controller: function(institucionalService, $scope, cacheService, $window){
                    cacheService.get({
                        chave:'institucional',
                        callback:function(institucional){
                            $scope.institucional = institucional;
                        }, 
                        supplier:function(callback){
                            institucionalService.carrega(function(institucional){
                                callback(institucional);
                            });
                        }
                    });
                    
                    $scope.mailto = function(email){
                        $window.open('mailto:' + email, '_system');
                    };
                    
                    $scope.tel = function(tel){
                        $window.open('tel:' + tel, '_system');
                    };
                    
                    $scope.geo = function(endereco){
                        $window.open('geo:0,0?q=' + endereco.descricao + ' ' + endereco.cidade + ' ' + endereco.estado, '_system');
                    };
                    
                    $scope.site = function(site){
                        if (site.indexOf('http://') < 0){
                            site = 'http://' + site;
                        }
                        $window.open(site, '_system');
                    };
                }
            }
        }
    });         
}]);
        