calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('leitura', {
        parent: 'site',
        url: '/leitura',
        views:{
            'content@':{
                templateUrl: 'js/leitura/leitura.list.html',
                controller: function(leituraService, $scope, sincronizacaoLeitura, $state){
                    var millisDia = 1000 * 60 * 60 * 24;
                    
                    $scope.$on('$ionicView.enter', function(){
                        recuperaRange();
                        
                        if (sincronizacaoLeitura.executando){
                            aguardaTerminoSincronizacao();
                        }
                    });
                    
                    var recuperaRange = function(){
                        leituraService.findRangeDatas().then(function(range){
                            if (range){
                                var hoje = new Date().getTime() / millisDia;
                                var inicio = range.dataInicio.getTime() / millisDia;
                                var termino = range.dataTermino.getTime() / millisDia;
                                
                                if (termino >= hoje){
                                    $scope.range = range;

                                    $scope.first = inicio - hoje;
                                    $scope.last = termino - hoje;
                                }else{
                                    $state.go('leitura.escolha');
                                }
                            }else if (!sincronizacaoLeitura.executando){
                                $state.go('leitura.escolha');
                            }
                        });
                    };
                    
                    var aguardaTerminoSincronizacao = function(){
                        $scope.sincronizacao = sincronizacaoLeitura;
                        
                        var stop = $scope.$watch('sincronizacao.executando', function(){
                            if (!$scope.sincronizacao.executando){
                                stop();
                                
                                recuperaRange();
                            }
                        });
                    };
                    
                    $scope.recuperaByIndex = function(index, callback){
                        leituraService.findByData(new Date(
                                $scope.range.dataInicio.getTime() + 
                                (index * millisDia))).then(callback);
                    };
                }
            }
        }
    }).state('leitura.escolha', {
        parent: 'leitura',
        url: '/escolha',
        views:{
            'content@':{
                templateUrl: 'js/leitura/leitura.form.html',
                controller: function(leituraService, $scope, $state){
                    $scope.searcher = function(page, callback){
                        leituraService.findPlanosDisponiveis({pagina:page}).then(callback);
                    };
                    
                    $scope.filtra = function(){
                        $scope.$broadcast('pagination.search');
                    };
                    
                    $scope.escolhe = function(plano){
                        leituraService.selecionaPlano(plano.id, function(){
                            leituraService.sincroniza();
                            $state.go('leitura.configuracao');
                        });
                    };
                    
                    $scope.filtra();
                }
            }
        }
    }).state('leitura.configuracao', {
        parent: 'leitura',
        url: '/config',
        views:{
            'content@':{
                templateUrl: 'js/leitura/leitura.conf.html',
                controller: function(leituraService, $scope, $state){
                    $scope.configuracao = {
                        desejaReceberNotificacoes: true,
                        horarioNotificacoes: '_14_00'
                    };
                    
                    $scope.salva = function(){
                        // Verificar se a configuração é melhor sendo offline ou online
                        $state.go('leitura');
                    };
                }
            }
        }
    });         
}]);
        