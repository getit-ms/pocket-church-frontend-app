calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('estudo', {
        parent: 'site',
        url: '/estudo',
        views:{
            'content@':{
                templateUrl: 'js/estudo/categoria.list.html',
                controller: function(estudoService, $state, $scope){
                    $scope.$on('$ionicView.enter', function() {
                      estudoService.buscaCategorias(function(categorias) {
                        $scope.categorias = categorias;
                      });
                    });
                }
            }
        }
    }).state('estudo.list', {
      parent: 'estudo',
      url: '/categoria/:categoria',
      views:{
        'content@':{
          templateUrl: 'js/estudo/estudo.list.html',
          controller: function(estudoService, $state, $scope, $stateParams){
            $scope.filtro = {categoria:$stateParams.categoria, total:10};

            $scope.searcher = function(page, callback){
              estudoService.busca(angular.extend({pagina:page}, $scope.filtro), function(estudos) {
                $scope.categoria = estudos.categoria;
                callback(estudos);
              });
            };

            $scope.detalhar = function(estudo){
              $state.go('estudo.view', {id: estudo.id});
            };
          }
        }
      }
    }).state('estudo.view', {
        parent: 'estudo',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/estudo/estudo.form.html',
                controller: function($scope, shareService, loadingService, config, pdfService, estudoService, $stateParams){
                    estudoService.carrega($stateParams.id, function(estudo) {

                      if (estudo.tipo == 'PDF') {
                        pdfService.get({
                          chave:'estudo',
                          id:$stateParams.id,
                          errorState:'estudo',
                          callback:function(estudo){
                            $scope.estudo = estudo;
                            $scope.totalPaginas = estudo.paginas.length;
                            loadingService.hide();
                            $state.reload();
                          },
                          supplier:function(id, callback){
                            loadingService.show();
                            callback(estudo);
                          }
                        });
                      } else {
                        $scope.estudo = estudo;
                      }
                    });

                    $scope.share = function(){
                        loadingService.show();

                        if ($scope.estudo.tipo == 'PDF') {
                          shareService.share({
                            subject:$scope.estudo.titulo,
                            file:config.server + '/rest/arquivo/download/' +
                            $scope.estudo.pdf.id + '/' +  $scope.estudo.pdf.filename + '?Dispositivo=' +
                            config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                            success: loadingService.hide,
                            error: loadingService.hide
                          });
                        } else {
                          shareService.share({
                            subject:$scope.estudo.titulo,
                            file: config.server + '/rest/estudo/' + $scope.estudo.id + '/' + $scope.estudo.filename + '.pdf?Dispositivo=' +
                            config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                            success: loadingService.hide,
                            error: loadingService.hide
                          });
                        }
                    };

                    $scope.updateSlideStatus = function(index) {
                      var zoomFactor = $ionicScrollDelegate.$getByHandle('scrollHandle' + index).getScrollPosition().zoom;
                      if (zoomFactor == 1) {
                        $ionicSlideBoxDelegate.enableSlide(true);
                      } else {
                        $ionicSlideBoxDelegate.enableSlide(false);
                      }
                    };

                }
            }
        }
    });
}]);
