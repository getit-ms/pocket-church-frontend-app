calvinApp.service('acessoService', ['Restangular', 'configService', function(Restangular, configService){
        this.api = function(){
            return Restangular.all('acesso');
        };

        this.carrega = function(success, error){
          var api = this.api();

          configService.load().then(function(config){
            api.get('', {versao:config.version}).then(success, error);
          });
        };

        this.login = function(login, success, error){
          var restLogin = this.api().one('login');

          configService.load().then(function(config){
            restLogin.customPUT(angular.extend({
              version:config.version,
              tipoDispositivo:config.tipo
            }, login)).then(success, error);
          });
        };

        this.logout = function(callback, errorCallback){
            this.api().one('logout').put().then(callback, errorCallback);
        };

        this.alteraSenha = function(dados, callback){
            this.api().one('senha/altera').customPUT(dados).then(callback);
        };

        this.solicitarRedefinicaoSenha = function(email, success, error){
            this.api().one('senha/redefinir/' + email).put().then(success, error);
        };

        this.buscaHorasVersiculoDiario = function(){
            return this.api().one('horariosVersiculoDiario').getList().$object;
        };

        this.buscaHorasLembretesLeitura = function(){
            return this.api().one('horariosLembretesLeitura').getList().$object;
        };

        this.buscaPreferencias = function(callback){
            return this.api().one('preferencias').get().then(callback);
        };

        this.salvaPreferencias = function(preferencias, callback){
            return this.api().one('preferencias').customPUT(preferencias).then(callback);
        };

        this.buscaMinisterios = function(){
            return this.api().one('ministerios').getList().$object;
        };

        this.buscaMenu = function(versao, success, error){
          var menuRest = this.api().one('menu');

          configService.load().then(function(config){
            menuRest.customGET('', {versao:config.version}).then(success, error);
          });
        };

        this.registerPushToken = function(token, callback){
            this.api().one('registerPush').customPOST(token).then(callback);
        };
}]);
