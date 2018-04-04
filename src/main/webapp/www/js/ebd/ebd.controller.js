calvinApp.config(['$stateProvider', function($stateProvider){
  $stateProvider.state('ebd', {
    parent: 'site',
    url: '/ebd',
    views:{
      'content@':{
        templateUrl: 'js/ebd/ebd.list.html',
        controller: function(eventoService, $state, $scope){
          $scope.searcher = function(page, callback){
            eventoService.busca({tipo:'EBD',pagina:page,total:10}, callback);
          };

          $scope.detalhar = function(ebd){
            $state.go('ebd.detalhe', {id: ebd.id});
          };
        }
      }
    }
  }).state('ebd.detalhe', {
    parent: 'ebd',
    url: '/:id',
    views:{
      'content@':{
        templateUrl: 'js/ebd/ebd.form.html',
        controller: function($scope, ebd, $state, eventoService, $ionicModal, arquivoService){
          $scope.ebd = ebd;

          $scope.searcherInscricoes = function(page, callback){
            eventoService.buscaMinhasInscricoes(ebd.id, {pagina:page,total:10}, callback);
          };

          $scope.zoomBaanner = function() {
            $ionicModal.fromTemplateUrl('js/ebd/banner.modal.html', {
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

          $scope.banner = function(ebd){
            if (!ebd || !ebd.banner) {
              return undefined;
            }

            if (!ebd.banner.localPath){
              ebd.banner.localPath = '#';
              arquivoService.get(ebd.banner.id, function(file){
                ebd.banner.localPath = file.file;
              }, function(file){
                ebd.banner.localPath = file.file;
              }, function(file){
                ebd.banner.localPath = file.file;
              });
            }

            return ebd.banner.localPath;
          };

          $scope.$on('$ionicView.enter', function(){
            $scope.$broadcast('pagination.search');
          });

          $scope.inscricao = function(){
            $state.go('ebd.inscricao', {id: $scope.ebd.id});
          };
        },
        resolve: {
          ebd: ['eventoService', '$stateParams', function(eventoService, $stateParams){
            return eventoService.carrega($stateParams.id);
          }]
        }
      }
    }
  }).state('ebd.inscricao', {
    parent: 'ebd',
    url: '/:id/inscricao',
    views:{
      'content@':{
        templateUrl: 'js/ebd/inscricao.form.html',
        controller: function(eventoService, $scope, ebd, loadingService,
                             message, $window, $ionicHistory, contatoService){
          $scope.ebd = ebd;

          $scope.$on('$ionicView.enter', function(){
            $scope.clear();
          });

          $scope.clear = function(){
            $scope.datasets = {};
            $scope.inscricoes = [];
            $scope.addInscricao();
          };

          $scope.addInscricao = function(){
            if ($scope.ebd.vagasRestantes > $scope.inscricoes.length){
              var inscricao;
              if ($scope.inscricoes.length){
                inscricao = {};
              }else{
                inscricao = {
                  nomeInscrito: $scope.usuario.nome,
                  emailInscrito: $scope.usuario.email,
                  telefoneInscrito: $scope.usuario.telefones &&
                  $scope.usuario.telefones.length ?
                    $scope.usuario.telefones[0] : ''
                };
              }

              $scope.datasets[$scope.inscricoes.length] = {
                minChars: 3,
                inscricao: inscricao,
                onSelect: function(contato)	{
                  var inscricao = this.inscricao;

                  inscricao.nomeInscrito = contato.nome;
                  inscricao.emailInscrito = contato.email;

                  contatoService.carregaCallback(contato.id, function(contato) {
                    if (contato.telefones) {
                      inscricao.telefoneInscrito = contato.telefones[0];
                    }
                  });
                },
                renderItem: function(item) {
                  return '<div class="item" ><h2>' + item.nome + '</h2><p>' + item.email + '</p></div>'
                },
                source: function(term, suggest){
                  contatoService.busca({nome:term}, function(contatos) {
                    if (contatos.resultados) {
                      suggest(contatos.resultados);
                    } else {
                      suggest([]);
                    }
                  });
                }
              };

              $scope.inscricoes.push(inscricao);
            }
          };

          $scope.removeInscricao = function(inscricao){
            $scope.inscricoes.splice($scope.inscricoes.indexOf(inscricao), 1);
          };

          $scope.conclui = function(){
            if ($scope.inscricoes.length){
              loadingService.show();

              eventoService.inscricao($scope.ebd.id, $scope.inscricoes, function(resposta){
                loadingService.hide();

                if (resposta.devePagar && resposta.checkoutPagSeguro){
                  message({title: 'global.title.200',template: 'mensagens.MSG-042'}, function(){
                    $ionicHistory.goBack();
                    $window.open('https://pagseguro.uol.com.br/v2/checkout/payment.html?code=' + resposta.checkoutPagSeguro, '_system');
                  });
                }else{
                  message({title: 'global.title.200',template: 'mensagens.MSG-001'});
                  $ionicHistory.goBack();
                }
              }, function(){
                loadingService.hide();
              });
            }
          };

          $scope.clear();
        },
        resolve: {
          ebd: ['eventoService', '$stateParams', function(eventoService, $stateParams){
            return eventoService.carrega($stateParams.id);
          }]
        }
      }
    }
  });
}]);
