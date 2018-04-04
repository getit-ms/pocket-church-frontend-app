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

            $ionicActionSheet.show({
              buttons: [
                {text:'Tirar Foto'},
                {text:'Escolher da Galeria'}
              ],
              cancelText: $filter('translate')('global.cancelar'),
              buttonClicked: function(index) {
                if (index >= 0) {

                  loadingService.show();

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
                    targetWidth: 300,
                    targetHeight: 300,
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

                      acessoService.atualizaFoto(arquivo, function() {

                        $scope.usuario.foto = arquivo;
                        loadingService.hide();
                        message({title:'global.title.200',template:'mensagens.MSG-001'});

                      }, function(error) {
                        console.error(error);
                        message({title:'global.title.500',template:'mensagens.MSG-052'});
                        loadingService.hide();
                      });

                    }, function(error) {
                      console.error(error);
                      message({title:'global.title.500',template:'mensagens.MSG-052'});
                      loadingService.hide();
                    });

                  }, function cameraError(error) {
                    console.error(error);
                    message({title:'global.title.500',template:'mensagens.MSG-051'});
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
