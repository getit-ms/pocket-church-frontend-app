calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('contato', {
        parent: 'site',
        url: '/contato',
        views:{
            'content@':{
                templateUrl: 'js/contato/contato.list.html',
                controller: function(contatoService, $state, $scope, $ionicScrollDelegate, $filter, $ionicFilterBar, $ionicFilterBarConfig, $ionicConfig){
                    $scope.filtro = {nome:'',total:50};
                    $scope.hasFilters = false;

                    const accents =
                      "ÀÁÂÃÄÅĄàáâãäåąßÒÓÔÕÕÖØÓòóôõöøóÈÉÊËĘèéêëęðÇĆçćÐÌÍÎÏìíîïÙÚÛÜùúûüÑŃñńŠŚšśŸÿýŽŻŹžżź";
                    const accentsOut =
                      "AAAAAAAAAAAAAABOOOOOOOOOOOOOOOEEEEEEEEEEECCCCDIIIIIIIIUUUUUUUUNNNNSSSSYYYZZZZZZ";

                    function letra(contato){
                      var letra = contato.nome.slice(0,1);
                      if (accents.indexOf(letra) >= 0) {
                        return accentsOut.charAt(accents.indexOf(letra));
                      }

                      return letra.toUpperCase();
                    }

                    $scope.searcher = function(page, callback){
                        contatoService.busca(angular.extend({pagina:page}, $scope.filtro), function(contatos) {
                          if (contatos.resultados) {
                            contatos.resultados.forEach(function(contato){
                              contato.letra = letra(contato);
                            })
                          }

                          callback(contatos);
                        });
                    };

                    $scope.showSearch = function(){
                        $ionicFilterBar.show({
                            items:[{}],
                            update: function(filter){

                            },
                            expression: function(filterText){
                                if (filterText != $scope.filtro.filtro){
                                    $ionicScrollDelegate.scrollTop();
                                    $scope.filtro.nome = filterText;
                                    $scope.filtra();
                                }
                            },
                            cancel: function(){
                                $scope.filtro.nome = '';
                                $scope.filtra();
                            },
                            cancelText: $filter('translate')('global.cancelar'),
                            config:{
                                theme: $ionicFilterBarConfig.theme(),
                                transition: $ionicFilterBarConfig.transition(),
                                back: $ionicConfig.backButton.icon(),
                                clear: $ionicFilterBarConfig.clear(),
                                favorite: $ionicFilterBarConfig.favorite(),
                                search: $ionicFilterBarConfig.search(),
                                backdrop: $ionicFilterBarConfig.backdrop(),
                                placeholder: $filter('translate')('global.buscar'),
                                close: $ionicFilterBarConfig.close(),
                                done: $ionicFilterBarConfig.done(),
                                reorder: $ionicFilterBarConfig.reorder(),
                                remove: $ionicFilterBarConfig.remove(),
                                add: $ionicFilterBarConfig.add()
                            }
                        });
                    };

                    $scope.detalhar = function(contato){
                        $state.go('contato.view', {id: contato.id});
                    };

                    $scope.filtra = function(){
                        $scope.$broadcast('pagination.search');
                    };

                    $scope.primeiroDaLetra = function(contatos, contato){
                        var idx = contatos.indexOf(contato);
                        return idx == 0 || contatos[idx - 1].letra != contato.letra;
                    };

                    $scope.filtra();
                }
            }
        }
    }).state('contato.aniversariantes', {
      parent: 'site',
      url: '/aniversariante',
      views:{
        'content@':{
          templateUrl: 'js/contato/aniversariantes.list.html',
          controller: function(contatoService, $state, $scope, $filter){

            var MILLIS_DIA = 1000 * 60 * 60 * 24;

            function toAniversario(data) {
              return (data.getMonth() + 1) * 100 + data.getDate();
            }

            $scope.busca = function(){
              var hoje = toAniversario(new Date());
              var amanha = toAniversario(new Date(new Date().getTime() + MILLIS_DIA));

              function aniversario(contato){
                if (amanha == contato.diaAniversario) {
                  return $filter('translate')('contato.amanha');
                }

                var dia = contato.diaAniversario % 100;
                var mes = Math.floor(contato.diaAniversario / 100);

                return dia + ' ' + $filter('translate')('global.mes.' + mes);
              }

              contatoService.buscaAniversariantes(function(aniversariantes) {
                $scope.hoje = aniversariantes.filter(function(contato) {
                  return contato.diaAniversario == hoje;
                });

                $scope.futuros = aniversariantes.filter(function(c) {
                  return c.diaAniversario != hoje;
                });

                $scope.futuros.forEach(function(contato){
                  contato.diaAniversarioFormatado = aniversario(contato);
                });

                $scope.$broadcast('scroll.refreshComplete');
              });
            };

            $scope.detalhar = function(contato){
              $state.go('contato.view', {id: contato.id});
            };

            $scope.primeiroDoMes = function(contatos, contato){
              var idx = contatos.indexOf(contato);
              return idx == 0 || contatos[idx - 1].diaAniversario != contato.diaAniversario;
            };

            $scope.$on('$ionicView.enter', function() {
              $scope.busca();
            });
          }
        }
      }
    }).state('contato.view', {
        parent: 'contato',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/contato/contato.form.html',
                controller: function($scope, contato, linkService){
                    $scope.contato = contato;

                    angular.extend($scope, linkService);
                },
                resolve: {
                    contato: ['contatoService', '$stateParams', function(contatoService, $stateParams){
                        return contatoService.carrega($stateParams.id);
                    }]
                }
            }
        }
    });
}]);
