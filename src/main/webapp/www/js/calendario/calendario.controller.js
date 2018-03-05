calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('calendario', {
            parent: 'site',
            url: '/calendario',
            views:{
                'content@':{
                    templateUrl: 'js/calendario/calendario.list.html',
                    controller: function(calendarioService, $scope, $ionicModal, shareService){
                      $scope.filtro = {total:50};
                      $scope.eventos = {dias:[]};

                      $scope.refresh = function() {
                        $scope.eventos = {dias:[]};
                        $scope.more();
                      };

                      $scope.more = function() {
                        calendarioService.busca(angular.extend($scope.filtro, {pagina: $scope.eventos.proximaPagina}), function(eventos) {
                          $scope.append(eventos);

                          $scope.$broadcast('scroll.infiniteScrollComplete');
                          $scope.$broadcast('scroll.refreshComplete');
                        });
                      };

                      $scope.primeiroDoMes = function(dias, dia){
                        var idx = dias.indexOf(dia);

                        if (idx === 0) {
                          return true;
                        } else {
                          var anterior = dias[idx - 1];
                          return dia.mes != anterior.mes || dia.ano != anterior.ano;
                        }
                      };

                      $scope.append = function(novaPagina) {
                        if (novaPagina.eventos) {
                          novaPagina.eventos.forEach(function(evento) {
                            if ($scope.eventos.dias.length) {
                              var dia = $scope.eventos.dias[$scope.eventos.length - 1];

                              if (dia.dia == evento.inicio.getDate() &&
                                  dia.mes == evento.inicio.getMonth() &&
                                  dia.ano == evento.getFullYear()) {

                                dia.eventos.push(evento);
                              } else {
                                var hoje = new Date();
                                $scope.eventos.dias.push({
                                  hoje: hoje.getDate() == evento.inicio.getDate() &&
                                        hoje.getMonth() == evento.inicio.getMonth() &&
                                        hoje.getFullYear() == evento.inicio.getFullYear(),
                                  dia: evento.inicio.getDate(),
                                  mes: evento.inicio.getMonth(),
                                  ano: evento.inicio.getFullYear(),
                                  eventos: [evento]
                                });
                              }
                            } else {
                              var hoje = new Date();
                              $scope.eventos.dias.push({
                                hoje: hoje.getDate() == evento.inicio.getDate() &&
                                      hoje.getMonth() == evento.inicio.getMonth() &&
                                      hoje.getFullYear() == evento.inicio.getFullYear(),
                                dia: evento.inicio.getDate(),
                                mes: evento.inicio.getMonth(),
                                ano: evento.inicio.getFullYear(),
                                eventos: [evento]
                              });
                            }
                          });
                        }
                        $scope.eventos.proximaPagina = novaPagina.proximaPagina;
                        $scope.hasMore = novaPagina.possuiProximaPagina;
                      };

                      $scope.refresh();
                    }
                }
            }
        });
    }]);
