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

                    $scope.searcher = function(page, callback){
                        contatoService.busca(angular.extend({pagina:page}, $scope.filtro), callback);
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

                    $scope.foto = function(contato){
                      if (!contato.foto.localPath){
                        contato.foto.localPath = '#';
                        arquivoService.get(contato.foto.id, function(file){
                          contato.foto.localPath = file.file;
                        }, function(file){
                          contato.foto.localPath = file.file;
                        }, function(file){
                          contato.foto.localPath = file.file;
                        });
                      }
                      return contato.foto.localPath;
                    };

                    $scope.detalhar = function(contato){
                        $state.go('contato.view', {id: contato.id});
                    };

                    $scope.filtra = function(){
                        $scope.$broadcast('pagination.search');
                    };

                    $scope.primeiroDaLetra = function(contatos, contato){
                        var idx = contatos.indexOf(contato);
                        return idx == 0 || $scope.letra(contatos[idx - 1]) != $scope.letra(contato);
                    };

                    $scope.letra = function(contato){
                        return contato.nome.slice(0,1).toUpperCase();
                    };

                    $scope.filtra();
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

                    $scope.foto = function(contato){
                      if (!contato.foto.localPath){
                        contato.foto.localPath = '#';
                        arquivoService.get(contato.foto.id, function(file){
                          contato.foto.localPath = file.file;
                        }, function(file){
                          contato.foto.localPath = file.file;
                        }, function(file){
                          contato.foto.localPath = file.file;
                        });
                      }
                      return contato.foto.localPath;
                    };
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
