calvinApp.config(['$stateProvider', function($stateProvider){
  $stateProvider.state('usuario', {
    parent: 'site',
    url: '/usuario',
    views:{
      'content@':{
        templateUrl: 'js/usuario/usuario.form.html',
        controller: function($scope, linkService, loadingService, $filter, $ionicActionSheet, acessoService, arquivoService, message){
          angular.extend($scope, linkService);

          $scope.trocarFoto = function() {

            loadingService.hide();

            $ionicActionSheet.show({
              buttons: [
                {text:'Tirar Foto'},
                {text:'Escolher da Galeria'}
              ],
              cancelText: $filter('translate')('global.cancelar'),
              buttonClicked: function(index) {
                if (index >= 0) {

                  var type = [
                    Camera.PictureSourceType.CAMERA,
                    Camera.PictureSourceType.PHOTOLIBRARY
                  ][index];

                  var options = {
                    // Some common settings are 20, 50, and 100
                    quality: 50,
                    destinationType: Camera.DestinationType.DATA_URL,
                    // In this app, dynamically set the picture source, Camera or photo gallery
                    sourceType: type,
                    encodingType: Camera.EncodingType.JPEG,
                    mediaType: Camera.MediaType.PICTURE,
                    allowEdit: true,
                    correctOrientation: true  //Corrects Android orientation quirks
                  };

                  navigator.camera.getPicture(function cameraSuccess(imageUri) {

                    arquivoService.upload({
                      fileName: $scope.usuario.nome + '.jpg',
                      data: imageUri
                    }, function(arquivo) {
                      $scope.usuario.foto = arquivo;
                      loadingService.hide();
                    }, function(error) {
                      message({title:'global.title.500',template:'mensagens.MSG-052'});
                      console.error(error);
                      loadingService.hide();
                    });

                  }, function cameraError(error) {
                    message({title:'global.title.500',template:'mensagens.MSG-051'});
                    console.error(error);
                    loadingService.hide();
                  }, options);
                }
                return true;
              }
            });
          };
        }
      }
    }
  });
}]);
