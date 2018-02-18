calvinApp.config(['$stateProvider', function($stateProvider){
        $stateProvider.state('calendario', {
            parent: 'site',
            url: '/calendario',
            views:{
                'content@':{
                    templateUrl: 'js/calendario/calendario.list.html',
                    controller: function(calendarioService, $scope, $ionicModal, shareService){
                      $scope.filtro = {total:50};
                      $scope.eventos = {};

                      $scope.refresh = function() {
                        $scope.eventos = {};
                        $scope.more();
                      };

                      $scope.more = function() {
                        calendarioService.busca(angular.extend($scope.filtro, {pagina: $scope.eventos.proximaPagina}), function(eventos) {
                          $scope.eventos = eventos;
                          $scope.hasMore = eventos.possuiProximaPagina;
                        });
                      };

                      $scope.primeiroDoMes = function(eventos, evento){
                        var idx = eventos.indexOf(evento);

                        if (idx === 0) {
                          return true;
                        } else {
                          var anterior = eventos[idx - 1];
                          return evento.inicio.getMonth() != anterior.inicio.getMonth() ||
                              evento.inicio.getFullYear() != anterior.inicio.getFullYear();
                        }
                      };

                      $scope.refresh();
                    }
                }
            }
        });
    }]);
