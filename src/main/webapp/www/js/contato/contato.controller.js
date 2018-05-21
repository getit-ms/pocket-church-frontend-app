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

            function aniversario(contato){
              var dia = contato.diaAniversario.substring(2);
              var mes = contato.diaAniversario.substring(0, 2);

              var hoje = new Date();
              var amanha = new Date(hoje.getTime() + 1000 * 60 * 60 * 24);

              if (Number(dia) == hoje.getDate() && Number(mes) == hoje.getMonth()) {
                return $filter('translate')('contato.hoje');
              } else if (Number(dia) == amanha.getDate() && Number(mes) == amanha.getMonth()) {
                return $filter('translate')('contato.amanha');
              }

              return dia + '/' + mes;
            }

            $scope.busca = function(){
              contatoService.buscaAniversariantes(function(aniversariantes) {
                contatos.resultados.forEach(function(contato){
                  contato.diaAniversarioFormatado = aniversario(contato);
                });

                $scope.aniversariantes = aniversariantes;
              });
            };

            $scope.detalhar = function(contato){
              $state.go('contato.view', {id: contato.id});
            };

            $scope.primeiroDoMes = function(contatos, contato){
              var idx = contatos.indexOf(contato);
              return idx == 0 || contatos[idx - 1].diaAniversarioFormatado != contato.diaAniversarioFormatado;
            };

            $scope.busca();
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
