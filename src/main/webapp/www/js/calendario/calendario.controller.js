calvinApp.config(['$stateProvider', function($stateProvider){
  $stateProvider.state('calendario', {
    parent: 'site',
    url: '/calendario',
    views:{
      'content@':{
        templateUrl: 'js/calendario/calendario.list.html',
        controller: function(calendarioService, $scope, $filter, $ionicPopup, message, loadingService, $ionicActionSheet){
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

          function createEvent(calendar, evento) {
            window.plugins.calendar.createEventWithOptions(
              evento.descricao,
              evento.local,
              undefined,
              evento.inicio,
              evento.termino,
              {
                calendarName: calendar.name,
                calendarId: calendar.id
              },
              function() {
                message({title:'global.title.200',template:'mensagens.MSG-001'});
                loadingService.hide();
              }, function() {
                message({title:'global.title.500',template:'mensagens.MSG-049'});
                loadingService.hide();
              }
            );
          }

          function doAdicionarNaAgenda(evento) {

            loadingService.show();

            window.plugins.calendar.listCalendars(function(calendars){

              if (calendars && calendars.length) {

                if (calendars.length == 1) {
                  createEvent(calendars[0], evento);
                } else {

                  var opcoes = [];
                  angular.forEach(calendars, function(cal) {
                    opcoes.push({text:cal.name});
                  });

                  loadingService.hide();

                  $ionicActionSheet.show({
                    buttons: opcoes,
                    titleText: $filter('translate')('mensagens.MSG-050'),
                    cancelText: $filter('translate')('global.cancelar'),
                    buttonClicked: function(index) {
                      if (index >= 0) {
                        loadingService.show();

                        createEvent(calendars[index], evento);
                      }
                      return true;
                    }
                  });

                }

              } else {
                message({title:'global.title.500',template:'mensagens.MSG-049'});
                loadingService.hide();
              }

            }, function() {
              message({title:'global.title.500',template:'mensagens.MSG-049'});
              loadingService.hide();
            });
          }

          $scope.adicionarNaAgenda = function(evento) {
            $ionicPopup.confirm({
              title:$filter('translate')('calendario.salvar_evento'),
              template: $filter('translate')('mensagens.MSG-048', {evento:evento.descricao}),
              okText:$filter('translate')('global.sim'),
              cancelText:$filter('translate')('global.nao')
            }).then(function(resp) {
              if (resp) {
                doAdicionarNaAgenda(evento);
              }
            });
          };

          $scope.append = function(novaPagina) {
            if (novaPagina.eventos) {
              angular.forEach(novaPagina.eventos, function(evento) {
                var dia = $scope.eventos.dias[$scope.eventos.dias.length - 1];

                if (dia &&
                    dia.dia == evento.inicio.getDate() &&
                    dia.mes == evento.inicio.getMonth() + 1 &&
                    dia.ano == evento.inicio.getFullYear()) {

                  dia.eventos.push(evento);
                } else {
                  var hoje = new Date();
                  $scope.eventos.dias.push({
                    hoje: hoje.getDate() == evento.inicio.getDate() &&
                          hoje.getMonth() == evento.inicio.getMonth() &&
                          hoje.getFullYear() == evento.inicio.getFullYear(),
                    dia: evento.inicio.getDate(),
                    mes: evento.inicio.getMonth() + 1,
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
