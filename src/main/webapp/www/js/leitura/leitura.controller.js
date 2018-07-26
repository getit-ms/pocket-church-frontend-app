calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('leitura', {
            parent: 'site',
            url: '/leitura',
            views:{
                'content@':{
                    templateUrl: 'js/leitura/leitura.form.html',
                    controller: function(leituraService, $scope, sincronizacaoLeitura, $state,
                    $ionicHistory, $filter){
                        $scope.$on('$ionicView.enter', function(){
                            leituraService.findPlano().then(function(plano){
                                if (plano){
                                    $scope.plano = plano;
                                    recuperaRange();
                                }else{
                                  $ionicHistory.nextViewOptions({
                                        disableBack: true
                                    });
                                    $state.go('leitura.escolha');
                                }
                            });

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

                                        $scope.datepicker.callback(new Date(hoje.getFullYear(), hoje.getMonth(), hoje.getDate()));

                                        leituraService.buscaDatasLidas(function(datas){
                                            angular.forEach(datas, function(dt){
                                                $scope.datepicker.highlights.push({
                                                    date:dt,
                                                    color:'#b3b3b3'
                                                });
                                            });
                                        });
                                    }
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

                            angular.forEach($scope.datepicker.highlights, function(h, i){
                                if (h.date.getTime() === $scope.leitura.dia.data.getTime()){
                                    idx = i;
                                }
                            });

                            if ($scope.leitura.lido && idx < 0){
                                $scope.datepicker.highlights.push({
                                    date:$scope.leitura.dia.data,
                                    color:'#b3b3b3'
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
                    templateUrl: 'js/leitura/leitura.list.html',
                    controller: function(leituraService, $scope, $state, loadingService, $ionicHistory){
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
                                $ionicHistory.nextViewOptions({
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
        });
    }]);
