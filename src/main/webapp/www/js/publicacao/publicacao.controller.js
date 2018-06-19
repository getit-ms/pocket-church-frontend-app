calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('publicacao', {
            parent: 'site',
            url: '/publicacao',
            views:{
                'content@':{
                    templateUrl: 'js/publicacao/publicacao.list.html',
                    controller: function(boletimService, $scope, $state, arquivoService){

                        $scope.searcher = function(page, callback){
                            boletimService.busca({pagina: page, total: 10, tipo: 'PUBLICACAO'}, callback);
                        };

                        $scope.thumbnail = function(publicacao){
                            if (!publicacao.thumbnail.localPath){
                                publicacao.thumbnail.localPath = '#';
                                arquivoService.get(publicacao.thumbnail.id, function(file){
                                    publicacao.thumbnail.localPath = file.file;
                                }, function(file){
                                    publicacao.thumbnail.localPath = file.file;
                                }, function(file){
                                    publicacao.thumbnail.localPath = file.file;
                                });
                            }
                            return publicacao.thumbnail.localPath;
                        };

                        $scope.primeiroDaLetra = function(publicacoes, publicacao){
                          var idx = publicacoes.indexOf(publicacao);
                          return idx == 0 || $scope.letra(publicacoes[idx - 1]) != $scope.letra(publicacao);
                        };

                        $scope.letra = function(publicacao){
                          return publicacao.titulo.slice(0,1).toUpperCase();
                        };

                        $scope.detalhar = function(publicacao){
                            $state.go('publicacao.view', {id: publicacao.id});
                        };
                    }
                }
            }
        }).state('publicacao.view', {
            parent: 'publicacao',
            url: '/:id',
            views:{
                'content@':{
                    templateUrl: 'js/publicacao/publicacao.form.html',
                    controller: function(boletimService, $scope, $stateParams, shareService, config, loadingService, arquivoService){
                      boletimService.carrega($stateParams.id, function(publicacao) {
                        $scope.publicacao = publicacao;
                      });

                      $scope.share = function(){
                        loadingService.show();

                        shareService.shareArquivo({
                          arquivo: $scope.publicacao.boletim,
                          success: loadingService.hide,
                          error: loadingService.hide
                        });
                      };

                    }
                }
            }
        });
    }]);
