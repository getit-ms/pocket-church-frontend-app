calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('biblia', {
        parent: 'site',
        url: '/biblia',
        views:{
            'content@':{
                templateUrl: 'js/biblia/livro.list.html',
                controller: function(bibliaService, $scope){                    
                    $scope.$on('$ionicView.enter', function(){
                        $scope.novoTestamento = bibliaService.buscaLivros('NOVO');
                        $scope.velhoTestamento = bibliaService.buscaLivros('VELHO');
                    });
                }
            }
        }
    }).state('biblia.livro', {
        parent: 'biblia',
        url:'/:livro',
        views:{
            'content@':{
                templateUrl: 'js/biblia/capitulo.list.html',
                controller: function(bibliaService, $scope, $stateParams){
                    $scope.livro = bibliaService.buscaLivro($stateParams.livro);
                    $scope.capitulos = bibliaService.buscaCapitulos($stateParams.livro);
                }
            }
        }
    }).state('biblia.capitulo', {
        parent: 'biblia.livro',
        url:'/:capitulo',
        views:{
            'content@':{
                templateUrl: 'js/biblia/capitulo.list.html',
                controller: function(bibliaService, $scope, $stateParams){
                    $scope.livro = bibliaService.buscaLivro($stateParams.livro);
                    $scope.capitulo = $stateParams.capitulo;
                    $scope.versiculos = bibliaService.buscaVersiculos($stateParams.livro, $stateParams.capitulo);
                }
            }
        }
    });         
}]);
        