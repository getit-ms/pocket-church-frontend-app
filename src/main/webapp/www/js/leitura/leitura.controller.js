calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('leitura', {
            parent: 'site',
            url: '/leitura',
            views:{
                'content@':{
                    templateUrl: 'js/leitura/leitura.list.html',
                    controller: function(leituraService, $scope, sincronizacaoLeitura, $state, 
                    $ionicViewService, $filter){
                        $scope.$on('$ionicView.enter', function(){
                            recuperaRange();
                            
                            if (sincronizacaoLeitura.executando){
                                aguardaTerminoSincronizacao();
                            }
                        });
                        
                        function updateProgresso(){
                            leituraService.findPorcentagem(function(progresso){
                                $scope.progresso = progresso;
                            });
                        }
                        
                        var recuperaRange = function(){
                            leituraService.findRangeDatas().then(function(range){
                                if (range){
                                    updateProgresso();
                                    
                                    var hoje = new Date();
                                    if (hoje.getTime() <= range.dataTermino.getTime()){
                                        $scope.datepicker = {
                                            date: hoje, 
                                            months: [
                                                $filter('translate')('global.mes.1'),
                                                $filter('translate')('global.mes.2'),
                                                $filter('translate')('global.mes.3'),
                                                $filter('translate')('global.mes.4'),
                                                $filter('translate')('global.mes.5'),
                                                $filter('translate')('global.mes.6'),
                                                $filter('translate')('global.mes.7'),
                                                $filter('translate')('global.mes.8'),
                                                $filter('translate')('global.mes.9'),
                                                $filter('translate')('global.mes.10'),
                                                $filter('translate')('global.mes.11'),
                                                $filter('translate')('global.mes.12')
                                            ],
                                            daysOfTheWeek: [
                                                $filter('translate')('global.semana.1'),
                                                $filter('translate')('global.semana.2'),
                                                $filter('translate')('global.semana.3'),
                                                $filter('translate')('global.semana.4'),
                                                $filter('translate')('global.semana.5'),
                                                $filter('translate')('global.semana.6'),
                                                $filter('translate')('global.semana.7')
                                            ],
                                            startDate: range.dataInicio,
                                            endDate: range.dataTermino,
                                            showDatepicker: true,
                                            calendarMode: true,
                                            highlights: [],
                                            callback: function(value){
                                                leituraService.findByData(value).then(function(leitura){
                                                    $scope.leitura = leitura;
                                                });
                                            }
                                        };
                                        
                                        leituraService.buscaDatasLidas(function(datas){
                                            datas.forEach(function(dt){
                                                $scope.datepicker.highlights.push({
                                                    date:dt,
                                                    color:'#bbb'
                                                });
                                            });
                                        });
                                        
                                    }else{
                                        $ionicViewService.nextViewOptions({
                                            disableBack: true
                                        });
                                        $state.go('leitura.escolha');
                                    }
                                }else if (!sincronizacaoLeitura.executando){
                                    $ionicViewService.nextViewOptions({
                                        disableBack: true
                                    });
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
                        
                        $scope.toggleLido = function(){
                            leituraService.atualizaLeitura($scope.leitura.dia.id, $scope.leitura.lido);
                            var idx = -1;
                            
                            $scope.datepicker.highlights.forEach(function(h, i){
                                if (h.date.getTime() === $scope.leitura.dia.data.getTime()){
                                    idx = i;
                                }
                            });
                            
                            if ($scope.leitura.lido && idx < 0){
                                $scope.datepicker.highlights.push({
                                    date:$scope.leitura.dia.data,
                                    color:'#bbb'
                                });
                            }else if (!$scope.leitura.lido && idx >= 0){
                                $scope.datepicker.highlights.splice(idx, 1);
                            }
                            
                            updateProgresso();
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
                    controller: function(leituraService, $scope, $state, loadingService, $ionicViewService){
                        $scope.searcher = function(page, callback){
                            leituraService.findPlanosDisponiveis({pagina:page}, callback);
                        };
                        
                        $scope.filtra = function(){
                            $scope.$broadcast('pagination.search');
                        };
                        
                        $scope.escolhe = function(plano){
                            loadingService.show();
                            
                            leituraService.selecionaPlano(plano.id, function(){
                                loadingService.hide();
                                leituraService.sincroniza();
                                $ionicViewService.nextViewOptions({
                                    disableBack: true
                                });
                                $state.go('leitura');
                            }, function(){
                                loadingService.hide();
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
                    controller: function($scope, acessoService, loadingService){
                        $scope.$on('$ionicView.enter', function(){
                            acessoService.buscaPreferencias(function(preferencias){
                                $scope.preferencias = preferencias;
                            });
                        });
                        
                        $scope.configuracao = {
                            desejaReceberNotificacoes: true,
                            horarioNotificacoes: '_14_00'
                        };
                        
                        $scope.horasLembrete = acessoService.buscaHorasLembretesLeitura();
                        
                        $scope.salva = function(form){
                            if (form.$invalid){
                                message({title:'global.title.400',template:'mensagens.MSG-002'})
                                return;
                            }
                            
                            loadingService.show();
                            
                            acessoService.salvaPreferencias($scope.preferencias, function(){
                                loadingService.hide();
                                message({title: 'global.title.200',template: 'mensagens.MSG-001'});
                            }, function(){
                                loadingService.hide();
                            });
                        };
                    }
                }
            }
        });         
    }]);
