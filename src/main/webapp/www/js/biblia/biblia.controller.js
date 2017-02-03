calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('biblia', {
            parent: 'site',
            url: '/biblia',
            views:{
                'content@':{
                    templateUrl: 'js/biblia/livro.list.html',
                    controller: function(bibliaService, $scope, sincronizacaoBiblia){
                        $scope.sincronizacao = sincronizacaoBiblia;

                        var buscaLivros = function(){
                            bibliaService.buscaLivros('NOVO').then(function(novoTestamento){
                                $scope.novoTestamento = novoTestamento;
                            });
                            bibliaService.buscaLivros('VELHO').then(function(velhoTestamento){
                                $scope.velhoTestamento = velhoTestamento;
                            });
                        };

                        $scope.$on('$ionicView.enter', function(){
                            if ($scope.sincronizacao.executando){
                                var stop = $scope.$watch('sincronizacao.executando', function(){
                                    if (!$scope.sincronizacao.executando){
                                        buscaLivros();
                                        stop();
                                    }
                                })
                            }
                        });

                      buscaLivros();
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
                      bibliaService.buscaLivro($stateParams.livro).then(function(livros){
                        $scope.livro = livros;
                      });

                      bibliaService.buscaCapitulos($stateParams.livro).then(function(capitulos){
                        $scope.capitulos = capitulos;
                      });
                    }
                }
            }
        }).state('biblia.capitulo', {
            parent: 'biblia.livro',
            url:'/:capitulo',
            views:{
                'content@':{
                    templateUrl: 'js/biblia/versiculo.list.html',
                    controller: function(bibliaService, $scope, $stateParams, shareService){
                      $scope.capitulo = $stateParams.capitulo;

                      bibliaService.buscaLivro($stateParams.livro).then(function(livro){
                        $scope.livro = livro;
                      });

                      bibliaService.buscaVersiculos($stateParams.livro, $stateParams.capitulo).then(function(versiculos){
                        $scope.versiculos = versiculos;
                      });

                      $scope.seleciona = function(versiculo){
                        if ($scope.selecionado == versiculo){
                          shareService.share({
                            message:versiculo.texto + ' (' + $scope.livro.nome + ' ' +
                            $scope.capitulo + ':' + versiculo.versiculo + ')'
                          });
                        }else{
                          $scope.selecionado = versiculo;
                        }
                      };
                    }
                }
            }
        });
    }]);
