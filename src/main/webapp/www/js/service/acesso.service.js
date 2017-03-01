calvinApp.service('acessoService', ['Restangular', 'config', function(Restangular, config){
        this.api = function(){
            return Restangular.all('acesso');
        };

        this.carrega = function(callback){
            this.api().get('').then(callback);
        };

        this.login = function(login, success, error){
            this.api().one('login').customPUT(angular.extend({
                version:config.version,
                tipoDispositivo:config.tipo
            }, login)).then(success, error);
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

        this.buscaFuncionalidadesPublicas = function(callback){
            return this.api().all('funcionalidades/publicas').getList().then(callback);
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

        this.registerPushToken = function(token, callback){
            this.api().one('registerPush').customPOST(token).then(callback);
        };
}]);
