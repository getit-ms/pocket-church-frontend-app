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
                    controller: function(boletimService, $scope, pdfService, $stateParams, shareService, config, loadingService, $state){
                        $scope.slide = {totalPaginas:0};

                        var dados = {porcentagem:0};

                        pdfService.get({
                            chave:'publicacao',
                            id:$stateParams.id,
                            errorState:'publicacao',
                            callback:function(publicacao){
                                $scope.publicacao = publicacao;
                                loadingService.hide();
                                $state.reload();
                            },
                            pagina:function(pag, total) {
                              dados.porcentagem = (pag/total) * 100;
                            },
                            supplier:function(id, callback){
                                loadingService.show(dados);
                                boletimService.carrega(id, callback);
                            }
                        });

                        $scope.share = function(){
                            loadingService.show();

                            shareService.share({
                                subject:$scope.publicacao.titulo,
                                file:config.server + '/rest/arquivo/download/' +
                                        $scope.publicacao.boletim.id + '/' +
                                        $scope.publicacao.boletim.filename + '?Dispositivo=' +
                                        config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                                success: loadingService.hide,
                                error: loadingService.hide
                            });
                        };
                    }
                }
            }
        });
    }]);
