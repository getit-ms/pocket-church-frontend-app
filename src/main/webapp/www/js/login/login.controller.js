calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('login', {
        parent: 'site',
        url: '/login',
        views:{
            'content@':{
                templateUrl: 'js/login/login.form.html',
                controller: function($scope, $rootScope, $state, message, acessoService, configService, $ionicHistory, loadingService, leituraService){
                    $scope.auth = {username:'',password:''};
                    $scope.efetuarLogin = function(form){
                        if (form.$invalid){
                            message({title:'global.title.200',template:'mensagens.MSG-002'});
                            return;
                        }

                        loadingService.show();

                        acessoService.login($scope.auth, function(acesso){
                          try {
                            $rootScope.usuario = acesso.membro;
                            $rootScope.carregaMenu(acesso.menu);

                            configService.save({
                              usuario:$rootScope.usuario,
                              menu:acesso.menu
                            });

                            if ($rootScope.funcionalidadeHabilitada('CONSULTAR_PLANOS_LEITURA_BIBLICA')){
                              leituraService.sincroniza();
                            }

                            loadingService.hide();

                            $ionicHistory.nextViewOptions({
                              historyRoot: true,
                              disableBack: true
                            });

                            $state.go('home');
                          } catch (ex) {
                            loadingService.hide();

                            message({title:'global.title.500',template:'mensagens.MSG-500',args:{mensagem:ex.message}});

                            console.log(ex);
                          }
                        }, function(){
                          loadingService.hide();
                        });
                    };
                }
            }
        }
    }).state('cadastroUsuario', {
      parent: 'site',
      url: '/cadastroUsuario',
      views:{
        'content@':{
          templateUrl: 'js/login/cadastro.form.html',
          controller: function($scope, $rootScope, $state, message, contatoService, configService, $ionicHistory, loadingService){
            $scope.usuario = {nome:'',email:'',telefone:''};
            $scope.realizarCadastro = function(form){
              if (form.$invalid){
                message({title:'global.title.200',template:'mensagens.MSG-002'});
                return;
              }

              loadingService.show();

              contatoService.cadastra($scope.usuario, function(contato){
                try {
                  loadingService.hide();

                  message({title:'global.title.200',template:'mensagens.MSG-057'});

                  $ionicHistory.nextViewOptions({
                    historyRoot: true,
                    disableBack: true
                  });

                  $state.go('home');
                } catch (ex) {
                  loadingService.hide();

                  message({title:'global.title.500',template:'mensagens.MSG-500',args:{mensagem:ex.message}});

                  console.log(ex);
                }
              }, function(){
                loadingService.hide();
              });
            };
          }
        }
      }
    }).state('alteraSenha', {
        parent: 'site',
        url: '/alteraSenha',
        views:{
            'content@':{
                templateUrl: 'js/login/alteraSenha.form.html',
                controller:['$scope', 'acessoService', 'message', '$rootScope', 'configService', '$state', '$ionicHistory',
                            function($scope, acessoService, message, $rootScope, configService, $state, $ionicHistory){
                    $scope.membro = {};

                    $scope.alteraSenha = function(){
                        if (!$scope.membro.novaSenha || !$scope.membro.confirmacaoSenha){
                            message({title:'global.title.400',template:'mensagens.MSG-002'});
                            return;
                        }

                        acessoService.alteraSenha($scope.membro, function(dados){
                            $rootScope.logout();
                            configService.save({
                                usuario:'',
                                menu:''
                            });
                            $ionicHistory.nextViewOptions({
                                historyRoot: true,
                                disableBack: true
                            });
                            $state.go('login');
                            message({title:'global.title.200',template:'mensagens.MSG-031'});
                        });
                    };
                }]
            }
        }
    }).state('redefineSenha', {
        parent: 'site',
        url: '/redefineSenha',
        views:{
            'content@':{
                templateUrl: 'js/login/redefine.form.html',
                controller:['$scope', 'acessoService', 'message', '$state', '$ionicHistory', 'loadingService',
                            function($scope, acessoService, message, $state, $ionicHistory, loadingService){
                    $scope.dados = {};

                    $scope.redefinirSenha = function(){
                        if (!$scope.dados.email){
                            message({title:'global.title.400',template:'mensagens.MSG-002'});
                            return;
                        }

                        loadingService.show();

                        acessoService.solicitarRedefinicaoSenha($scope.dados.email, function(dados){
                            loadingService.hide();
                            message({title:'global.title.200',template:'mensagens.MSG-038'});
                            $ionicHistory.nextViewOptions({
                                historyRoot: true,
                                disableBack: true
                            });
                            $state.go('login');
                        }, loadingService.hide);
                    };
                }]
            }
        }
    });
}]);
