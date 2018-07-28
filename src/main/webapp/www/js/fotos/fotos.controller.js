calvinApp.config(['$stateProvider', function($stateProvider){
  $stateProvider.state('foto', {
    parent: 'site',
    url: '/foto',
    views:{
      'content@':{
        templateUrl: 'js/fotos/fotos.list.html',
        controller: function(fotoService, $state, $scope){
          $scope.searcher = function(page, callback){
            fotoService.buscaGalerias(page, callback);
          };

          $scope.detalhar = function(galeria){
            $state.go('foto.detalhe', {galeria: galeria.id});
          };
        }
      }
    }
  }).state('foto.detalhe', {
    parent: 'foto',
    url: '/:galeria',
    views:{
      'content@':{
        templateUrl: 'js/fotos/fotos.form.html',
        controller: function($scope, $state, $stateParams, fotoService, $ionicModal, shareService){
          $scope.refresh = function(){
            $scope.page = 0;
            $scope.fotos = [];
            $scope.hasMore = false;

            $scope.more();
          };

          $scope.more = function(callback){
            $scope.page++;

            fotoService.buscaFotos($stateParams.galeria, $scope.page, function(pagina) {
              if (pagina && pagina.resultados) {
                angular.forEach(pagina.resultados, function(d){
                  $scope.fotos.push(d);
                });
              }

              if (callback) {
                callback();
              }

              $scope.$broadcast('scroll.infiniteScrollComplete');
              $scope.$broadcast('masonry.reload');

              $scope.totalFotos = pagina.totalResultados;
              $scope.hasMore = pagina.hasProxima;
            }, function() {
              $scope.$broadcast('scroll.infiniteScrollComplete');
            });

          };

          $scope.compartilhar = function() {
            var fto = $scope.fotos[$scope.status.pagina - 1];

            shareService.share({
              link: 'https://farm' + fto.farm + '.staticflickr.com/'+ fto.server + '/' + fto.id + '_' + fto.secret + '_b.jpg'
            });
          };

          $scope.fotoSupplier = function(nr, callback) {
            if (nr > $scope.fotos.length) {
              if (nr <= $scope.totalFotos) {
                $scope.more(function() {
                  $scope.fotoSupplier(nr, callback);
                });
              }
            } else {
              var fto = $scope.fotos[nr - 1];

              callback({url: 'https://farm' + fto.farm + '.staticflickr.com/'+ fto.server + '/' + fto.id + '_' + fto.secret + '_b.jpg'});
            }
          };

          $scope.openModal = function (foto) {
            $scope.status = {pagina: $scope.fotos.indexOf(foto) + 1,click:function() {
              $scope.barsHidden = !$scope.barsHidden;
            }};
            $scope.barsHidden = true;

            $ionicModal.fromTemplateUrl('js/fotos/foto-gallery.modal.html', {
              scope: $scope,
              animation: 'slide-in-up'
            }).then(function(modal) {
              $scope.modal = modal;
              $scope.modal.show();
            });
          };

          $scope.$on('modal.hidden', function() {
            $scope.closeModal();
          });

          $scope.$on('$ionicView.leave', function() {
            $scope.closeModal();
          });

          $scope.closeModal = function() {
            if ($scope.modal){
              var modal = $scope.modal;

              $scope.modal = undefined;

              modal.hide();
              modal.remove();
            }
          };

          $scope.$on('pagination.search', function() {
            $scope.refresh();
          });

          $scope.$on('pagination.refresh', function() {
            $scope.refresh();
          });

          $scope.$on('pagination.more', function() {
            $scope.more();
          });

          $scope.refresh();
        }
      }
    }
  });
}]);
