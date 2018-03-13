calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('noticia', {
        parent: 'site',
        url: '/noticia',
      views:{
        'content@':{
          templateUrl: 'js/noticia/noticia.list.html',
          controller: function(noticiaService, $state, $scope, arquivoService){
            $scope.filtro = {total:10};

            $scope.searcher = function(page, callback){
              noticiaService.busca(angular.extend({pagina:page}, $scope.filtro), function(noticias) {
                $scope.categoria = noticias.categoria;
                callback(noticias);
              });
            };

            $scope.foto = function(autor){
              if (!autor || !autor.foto) {
                return undefined;
              }

              if (!autor.foto.localPath){
                autor.foto.localPath = '#';
                arquivoService.get(autor.foto.id, function(file){
                  autor.foto.localPath = file.file;
                }, function(file){
                  autor.foto.localPath = file.file;
                }, function(file){
                  autor.foto.localPath = file.file;
                });
              }
              return autor.foto.localPath;
            };

            $scope.ilustracao = function(noticia){
              if (!noticia || !noticia.ilustracao ) {
                return undefined;
              }

              if (!noticia.ilustracao.localPath){
                noticia.ilustracao.localPath = '#';
                arquivoService.get(noticia.ilustracao.id, function(file){
                  noticia.ilustracao.localPath = file.file;
                }, function(file){
                  noticia.ilustracao.localPath = file.file;
                }, function(file){
                  noticia.ilustracao.localPath = file.file;
                });
              }
              return noticia.ilustracao.localPath;
            };

            $scope.detalhar = function(noticia){
              $state.go('noticia.view', {id: noticia.id});
            };
          }
        }
      }
    }).state('noticia.view', {
        parent: 'noticia',
        url: '/:id',
        views:{
            'content@':{
                templateUrl: 'js/noticia/noticia.form.html',
                controller: function($scope, shareService, loadingService, config, pdfService, arquivoService,
                                     noticiaService, $state, $stateParams, $ionicScrollDelegate, $ionicSlideBoxDelegate, $ionicModal){
                    noticiaService.carrega($stateParams.id, function(noticia) {
                      $scope.noticia = noticia;
                    });

                    $scope.share = function(){
                        loadingService.show();

                        shareService.share({
                          subject:$scope.noticia.titulo,
                          file: config.server + '/rest/noticia/' + $scope.noticia.id + '/' + $scope.noticia.filename + '.pdf?Dispositivo=' +
                          config.headers.Dispositivo + '&Igreja=' + config.headers.Igreja,
                          success: loadingService.hide,
                          error: loadingService.hide
                        });
                    };

                    $scope.zoomIlustracao = function() {
                      $ionicModal.fromTemplateUrl('js/noticia/ilustracao.modal.html', {
                        scope: $scope,
                        animation: 'slide-in-up'
                      }).then(function(modal) {
                        $scope.modal = modal;
                        $scope.modal.show();
                      });
                    };

                    $scope.closeModal = function() {
                      if ($scope.modal){
                        $scope.modal.hide();
                        $scope.modal.remove();
                      }
                    };

                    $scope.ilustracao = function(noticia){
                      if (!noticia || !noticia.ilustracao ) {
                        return undefined;
                      }

                      if (!noticia.ilustracao.localPath){
                        noticia.ilustracao.localPath = '#';
                        arquivoService.get(noticia.ilustracao.id, function(file){
                          noticia.ilustracao.localPath = file.file;
                        }, function(file){
                          noticia.ilustracao.localPath = file.file;
                        }, function(file){
                          noticia.ilustracao.localPath = file.file;
                        });
                      }
                      return noticia.ilustracao.localPath;
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
