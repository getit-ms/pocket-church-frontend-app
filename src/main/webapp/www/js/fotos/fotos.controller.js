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
        controller: function($scope, $state, $stateParams, fotoService, $ionicModal){
          $scope.searcher = function(page, callback){
            fotoService.buscaFotos($stateParams.galeria, page, function(pagina) {
              $scope.totalFotos = pagina.totalResultados;
              callback(pagina);
            });
          };

          $scope.fotoSupplier = function(nr, callback) {
            if (nr > $scope.fotos.length) {
              $scope.searcher(Math.ceil($scope.fotos.length / 30) + 1, function(pagina) {
                angular.forEach(pagina.resultados, function(i) {
                  $scope.fotos.push(i);
                });

                if (nr <= pagina.totalResultados) {
                  $scope.fotoSupplier(nr, callback);
                }
              });
            } else {
              var fto = $scope.fotos[nr - 1];

              callback({url: 'https://farm' + fto.farm + '.staticflickr.com/'+ fto.server + '/' + fto.id + '_' + fto.secret + '_b.jpg'});
            }
          };

          $scope.openModal = function (page) {
            $scope.status = {pagina: page.pageIndex + 1,click:function() {
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

          $scope.$on('$ionicView.enter', function(){
            $scope.$broadcast('pagination.search');
          });
        }
      }
    }
  });
}]);
