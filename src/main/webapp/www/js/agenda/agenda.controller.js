calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('agenda', {
            parent: 'site',
            url: '/agenda',
            views:{
                'content@':{
                    templateUrl: 'js/agenda/agenda.list.html',
                    controller: function(agendaService, $scope, message, $ionicPopup, $filter, $ionicViewService, $state){
                        $scope.searcher = function(page, callback){
                            agendaService.busca({pagina:page,total:10}, function(agendamentos){
                                if ($scope.usuario.pastor || agendamentos.totalResultados){
                                    callback(agendamentos);
                                }else{
                                    $ionicViewService.nextViewOptions({
                                        disableBack: true
                                    });
                                    $state.go('agenda.novo');
                                }
                            });
                        };
                        
                        $scope.confirma = function(agendamento){
                            agendaService.confirma(agendamento.calendario.id, agendamento.id, function(dados){
                                message({title:'global.title.200',template:'mensagens.MSG-001'});
                                $scope.$broadcast('pagination.refresh');
                            });
                        };
                        
                        $scope.cancela = function(agendamento){
                            $ionicPopup.confirm({
                                title:$filter('translate')('agenda.confirmacao_cancelamento'),
                                template:$filter('translate')('mensagens.MSG-035', {
                                    data:$filter('date')(agendamento.dataHoraInicio, 
                                        $filter('translate')('config.pattern.date')),
                                    horaInicio:$filter('date')(agendamento.dataHoraInicio, 
                                        $filter('translate')('config.pattern.hour')),
                                    horaFim:$filter('date')(agendamento.dataHoraFim, 
                                        $filter('translate')('config.pattern.hour'))
                                }),
                                okText:$filter('translate')('global.sim'),
                                cancelText:$filter('translate')('global.nao')
                            }).then(function(resp){
                                if (resp){
                                    agendaService.cancela(agendamento.calendario.id, agendamento.id, function(dados){
                                        message({title:'global.title.200',template:'mensagens.MSG-001'});
                                        $scope.$broadcast('pagination.refresh');
                                    });
                                }
                            });
                        };
                        
                    }
                }
            }
        }).state('agenda.novo', {
            parent: 'agenda',
            url: '/agenda/novo',
            views:{
                'content@':{
                    templateUrl: 'js/agenda/agenda.form.html',
                    controller: function(agendaService, $scope, message, $state, $ionicViewService, $filter, $ionicLoading){
                        $scope.clear = function(){
                            $scope.agendamento = {};
                            $scope.calendarioSelecionado = null;
                            $scope.calendarios = agendaService.buscaCalendarios();
                        };
                        
                        var currentDate = new Date();
                        
                        $scope.datepicker = {
                            date: currentDate, 
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
                            startDate: new Date(Date.UTC(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate())),
                            endDate: new Date(Date.UTC(currentDate.getFullYear(), currentDate.getMonth() + 3, currentDate.getDate())),
                            disablePastDays: true,
                            showDatepicker: true,
                            calendarMode: true,
                            highlights: [],
                            callback: function(value){
                                if ($scope.horarios){
                                    atualizaHorarios(value);
                                }
                            }
                        };
                        
                        function atualizaHorarios(value){
                            $scope.horariosDia = [];
                            $scope.horarios.forEach(function(horario){
                                var date = new Date(horario.dataInicio);
                                if (date.getDate() === $scope.datepicker.date.getDate() &&
                                        date.getMonth() === $scope.datepicker.date.getMonth() &&
                                        date.getFullYear() === $scope.datepicker.date.getFullYear()){
                                    $scope.horariosDia.push(horario);
                                }
                            });
                            if ($scope.horariosDia.length){
                                $scope.agendamento.data = value;
                            }else{
                                $scope.agendamento.data = null;
                            }
                        }
                        
                        $scope.calendarioModificado = function(calendario){
                            if (calendario){
                                $scope.horarios = [];
                                $scope.datepicker.highlights = [];
                                $scope.horariosDia = [];
                                $scope.agendamento.data = undefined;
                                
                                $ionicLoading.show({template:'<ion-spinner icon="spiral" class="spinner spinner-spiral"></ion-spinner> ' + $filter('translate')('global.carregando')});
                                
                                $scope.datepicker.highlights = [];
                                agendaService.buscaAgenda(calendario.id,  {
                                    di:$scope.datepicker.startDate, 
                                    df:$scope.datepicker.endDate
                                }, function(horarios){
                                    if (!horarios.length){
                                        message({title:'agenda.sem_horarios_disponiveis',template:'mensagens.MSG-033'});
                                    }
                                    
                                    $scope.horarios = horarios;
                                    $scope.horarios.forEach(function(horario){
                                        $scope.datepicker.highlights.push({
                                            date:horario.dataInicio,
                                            color:'#bbb'
                                        });
                                    });
                                    
                                    atualizaHorarios($scope.datepicker.date);
                                    
                                    $ionicLoading.hide();
                                }, function(){
                                    $ionicLoading.hide();
                                });
                            }
                        };
                        
                        $scope.solicitar = function(calendario){
                            agendaService.agenda(calendario.id, $scope.agendamento, function(){
                                message({title:'global.title.200',template:'mensagens.MSG-029'});
                                $ionicViewService.nextViewOptions({
                                    disableBack: true
                                });
                                $state.go('agenda');
                            });
                        };
                        
                        $scope.clear();
                        
                    }
                }
            }
        });;         
    }]);
