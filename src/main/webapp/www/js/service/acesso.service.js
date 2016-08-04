calvinApp.service('acessoService', ['Restangular', 'config', function(Restangular, config){
        this.api = function(){
            return Restangular.all('acesso');
        };
        
        this.carrega = function(callback){
            this.api().get('').then(callback);
        };
        
        this.login = function(login, callback){
            this.api().one('login').customPUT(angular.extend({
                version:config.version, 
                tipoDispositivo:config.tipo
            }, login)).then(callback);
        };
        
        this.logout = function(callback, errorCallback){
            this.api().one('logout').put().then(callback, errorCallback);
        };
        
        this.alteraSenha = function(dados, callback){
            this.api().one('senha/altera').customPUT(dados).then(callback);
        };
        
        this.solicitarRedefinicaoSenha = function(email, callback){
            this.api().one('senha/redefinir/' + email).put().then(callback);
        };
        
        this.buscaHorasVersiculoDiario = function(){
            return this.api().one('horariosVersiculoDiario').getList().$object;
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
        
        this.registerPushToken = function(token){
            this.api().one('registerPush').customPOST(token);
        };
        
        this.unregisterPushToken = function(regId){
            this.api().one('unregisterPush').customPOST(regId);
        };
}]);
        