calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('biblia', {
            parent: 'site',
            url: '/biblia',
            views:{
                'content@':{
                    templateUrl: 'js/biblia/livro.list.html',
                    controller: function(bibliaService, $scope, sincronizacaoBiblia){
                        $scope.sincronizacao = sincronizacaoBiblia;

                        var verificaMarcacao = function(){
                            if ($scope.marcacao){
                                if ($scope.novoTestamento){
                                    $scope.novoTestamento.forEach(function(livro){
                                        livro.marcado = $scope.marcacao.livro == livro.abreviacao;
                                    });
                                }
                                    
                                if ($scope.velhoTestamento){
                                    $scope.velhoTestamento.forEach(function(livro){
                                        livro.marcado = $scope.marcacao.livro == livro.abreviacao;
                                    });
                                }
                            }
                        };
                        
                        var buscaLivros = function(){
                            bibliaService.buscaLivros('NOVO').then(function(novoTestamento){
                                $scope.novoTestamento = novoTestamento;
                                
                                verificaMarcacao();
                            });
                            bibliaService.buscaLivros('VELHO').then(function(velhoTestamento){
                                $scope.velhoTestamento = velhoTestamento;
                                
                                verificaMarcacao();
                            });
                        };

                        $scope.$on('$ionicView.enter', function(){
                            if (!$scope.sincronizacao.executando){
                                bibliaService.sincroniza();
                            }
                            registraWatcher();
                            
                            var smarcacao = window.localStorage.getItem('marcacao_biblia');
                            if (smarcacao){
                                $scope.marcacao = angular.fromJson(smarcacao);
                                
                                verificaMarcacao();
                            }
                        });

                        function registraWatcher(){
                            var stop = $scope.$watch('sincronizacao.porcentagem', function(){
                                buscaLivros();
                                if (!$scope.sincronizacao.executando){
                                    $scope.$broadcast('scroll.refreshComplete');
                                    stop();
                                }
                            });
                        }

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
                        $scope.$on('$ionicView.enter', function(){
                            var smarcacao = window.localStorage.getItem('marcacao_biblia');
                            if (smarcacao){
                                $scope.marcacao = angular.fromJson(smarcacao);
                            }
                        });
                        
                        bibliaService.buscaLivro($stateParams.livro).then(function(livro){
                            $scope.livro = livro;
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
                    controller: function(bibliaService, $scope, $stateParams, shareService, $ionicListDelegate){
                        $scope.capitulo = $stateParams.capitulo;
                      
                        $scope.$on('$ionicView.enter', function(){
                            var smarcacao = window.localStorage.getItem('marcacao_biblia');
                            if (smarcacao){
                                $scope.marcacao = angular.fromJson(smarcacao);

                                verificaMarcacao();
                            }
                        });
                        
                        var verificaMarcacao = function(){
                            if ($scope.marcacao && $scope.versiculos && $scope.livro &&
                                    $scope.marcacao.livro == $scope.livro.abreviacao &&
                                    $scope.marcacao.capitulo == $scope.capitulo){
                                $scope.versiculos.forEach(function(versiculo){
                                    versiculo.marcado = versiculo.versiculo == $scope.marcacao.versiculo;
                                    if (versiculo.marcado){
                                        if ($scope.marcado){
                                            $scope.marcado.marcado = false;
                                        }
                                        
                                        $scope.marcado = versiculo;
                                    }
                                });
                            }
                        };

                        bibliaService.buscaLivro($stateParams.livro).then(function(livro){
                            $scope.livro = livro;

                            bibliaService.buscaVersiculos($stateParams.livro, $stateParams.capitulo).then(function(versiculos){
                                $scope.versiculos = versiculos;

                                verificaMarcacao();
                            });
                        });
                      
                        $scope.compartilhar = function(versiculo){
                            shareService.share({
                                message:versiculo.texto + ' (' + $scope.livro.nome + ' ' +
                                        $scope.capitulo + ':' + versiculo.versiculo + ')'
                            });
                            
                            $ionicListDelegate.closeOptionButtons();
                        };
                      
                        $scope.marcar = function(versiculo){
                            $scope.marcacao = {
                                versiculo: versiculo.versiculo,
                                capitulo: $scope.capitulo,
                                livro: $scope.livro.abreviacao
                            };
                                
                            window.localStorage.setItem('marcacao_biblia', angular.toJson($scope.marcacao));
                            
                            if ($scope.marcado){
                                $scope.marcado.marcado = false;
                            }
                            $scope.marcado = versiculo;
                            versiculo.marcado = true;
                            
                            $ionicListDelegate.closeOptionButtons();
                        };
                    }
                }
            }
        });
    }]);
