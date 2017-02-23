calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('login', {
        parent: 'site',
        url: '/login',
        views:{
            'content@':{
                templateUrl: 'js/login/login.form.html',
                controller: function($scope, $rootScope, $state, message, acessoService, configService, $ionicViewService, loadingService, leituraService){
                    $scope.auth = {username:'',password:''};
                    $scope.efetuarLogin = function(form){
                        if (form.$invalid){
                            message({title:'global.title.200',template:'mensagens.MSG-002'})
                            return;
                        }
                        
                        loadingService.show();
                        
                        acessoService.login($scope.auth, function(acesso){
                            $rootScope.usuario = acesso.membro;
                            $rootScope.funcionalidades = acesso.funcionalidades;
                            
                            configService.save({
                                usuario:$rootScope.usuario,
                                funcionalidades:acesso.funcionalidades
                            });
                            
                            $ionicViewService.nextViewOptions({
                                historyRoot: true,
                                disableBack: true
                            });
                            
                            if ($rootScope.funcionalidades &&
                                    $rootScope.funcionalidades.indexOf('CONSULTAR_PLANOS_LEITURA_BIBLICA') >= 0){
                                leituraService.sincroniza();
                            }
                            
                            loadingService.hide();
                            
                            $state.go('home');
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
                controller:['$scope', 'acessoService', 'message', '$rootScope', 'configService', '$state', '$ionicViewService',
                            function($scope, acessoService, message, $rootScope, configService, $state, $ionicViewService){
                    $scope.membro = {};

                    $scope.alteraSenha = function(){
                        if (!$scope.membro.novaSenha || !$scope.membro.confirmacaoSenha){
                            message({title:'global.title.400',template:'mensagens.MSG-002'})
                            return;
                        }

                        acessoService.alteraSenha($scope.membro, function(dados){
                            $rootScope.usuario = null;
                            $rootScope.funcionalidades = null;
                            configService.save({
                                usuario:'',
                                funcionalidades:''
                            });
                            $ionicViewService.nextViewOptions({
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
                controller:['$scope', 'acessoService', 'message', '$state', '$ionicViewService',
                            function($scope, acessoService, message, $state, $ionicViewService){
                    $scope.dados = {};
                                
                    $scope.redefinirSenha = function(){
                        if (!$scope.dados.email){
                            message({title:'global.title.400',template:'mensagens.MSG-002'})
                            return;
                        }

                        acessoService.solicitarRedefinicaoSenha($scope.dados.email, function(dados){
                            message({title:'global.title.200',template:'mensagens.MSG-038'});
                            $ionicViewService.nextViewOptions({
                                historyRoot: true,
                                disableBack: true
                            });
                            $state.go('login');
                        });
                    };
                }]
            }
        }
    });         
}]);
        