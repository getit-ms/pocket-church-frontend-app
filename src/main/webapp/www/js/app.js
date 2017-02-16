// Ionic Starter App

angular.module('underscore', [])
        .factory('_', function () {
            return window._; // assumes underscore has already been loaded on the page
});

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
var calvinApp = angular.module('calvinApp', [
    'ionic',
    'ionic.service.core',
    'ionic.service.push',
    'pascalprecht.translate',
    'ngCordova',
    'angularUtils.directives.uiBreadcrumbs',
    'ui.mask',
    'restangular',
    'ngSanitize',
    'onezone-datepicker',
    'underscore',
    'ngResource',
    'jett.ionic.filter.bar',
    'youtube-embed'
]).run(function ($ionicPlatform, PushNotificationsService, $rootScope, configService, notificacaoService, $cordovaLocalNotification,
arquivoService, cacheService, $injector, boletimService, $cordovaBadge, bibliaService, database, hinoService) {
    function countNotificacoes(){
        notificacaoService.count(function(dados){
            $rootScope.notifications = dados.count;
            $cordovaBadge.set(dados.count);
        }, function(){});
    }

    $ionicPlatform.on("resume", function(){
        countNotificacoes();
        $cordovaLocalNotification.clearAll();
    });

    $ionicPlatform.on("deviceready", function () {
        // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
        // for form inputs)
        if (window.cordova && window.cordova.plugins.Keyboard) {
            cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
        }
        if (window.StatusBar) {
            StatusBar.styleDefault();
        }

        var versaoAtualizada = $_version != configService.load().version;

        configService.save({
            version: $_version,
            tipo: ionic.Platform.isAndroid() ? 0 : 1
        });

        if (!configService.load().headers.Dispositivo ||
                configService.load().headers.Dispositivo == 'undefined'){
            configService.save({
                headers:{
                    Dispositivo: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
                        return v.toString(16);
                    })
                }
            });
        }

        PushNotificationsService.register(versaoAtualizada);

        $rootScope.deviceReady = true;

        countNotificacoes();

        try{
            database.init();

            bibliaService.sincroniza();

            hinoService.sincroniza();

            arquivoService.init();

            boletimService.cache();

            cacheService.clean();

            arquivoService.clean();
        }catch(e){
            console.error(e);
        }

        $injector.get('$state').reload();
    });

}).service('loadingService', ['$ionicLoading', '$filter', function($ionicLoading, $filter){
      this.show = function(){
          $ionicLoading.show({
              template:'<ion-spinner class="spinner-light"></ion-spinner><br/><br/>' + $filter('translate')('global.carregando'),
              animation: 'fade-in'
          });
      };

      this.hide = function(){
          $ionicLoading.hide();
      };
}]).value('config', {
    server: $_serverUrl,
    ios: {
        name: $_serverCode
    },
    headers: {
        Igreja: $_serverCode,
        Dispositivo: 'undefined'
    }
}).service('configService', ['config', '$window', function (config, $window) {
        this.load = function () {
            var cfg = $window.localStorage.getItem('config');
            if (!cfg) {
                this.save({});
                cfg = $window.localStorage.getItem('config');
            }

            return angular.merge(config, angular.fromJson(cfg));
        };

        this.save = function (cfg) {
            $window.localStorage.setItem('config', angular.toJson(angular.merge(config, cfg)));
        };
    }]);

function configureHttpInterceptors($httpProvider) {
    $httpProvider.interceptors.push(['$q', '$rootScope', 'backendErrors', 'configService', '$injector',
        function ($q, $rootScope, backendErrors, configService, $injector) {
            return {
                request: function (request) {
                    if (request.method === 'DELETE') {
                        request.headers['Content-Length'] = 0;
                        request.headers['Content-Type'] = 'application/json;charset=UTF-8';
                        request.data = '';
                    }

                    angular.extend(request.headers, configService.load().headers);

                    return request;
                },
                response: function(response){
                    if (response.headers('Set-Authorization')){
                        configService.save({headers:{Authorization:response.headers('Set-Authorization')}});
                    }

                    return response;
                },
                responseError: function (rejection) {
                    var responseInterceptors = {
                        400: function (rejection) { // BAD REQUEST
                            $injector.get('message')({
                                title: 'global.title.400',
                                template: rejection.data.message
                            });

                            if (rejection.data.validations) {
                                rejection.data.validations.forEach(function (erro) {
                                    backendErrors.set(erro.field, erro.message, erro.args);
                                });
                            }
                            $rootScope.$broadcast('scroll.infiniteScrollComplete');
                        },
                        401: function (rejection) { // UNAUTHORIZED
                            $injector.get('message')({
                                title: 'global.title.401',
                                template: rejection.data.message
                            });
                            $rootScope.$broadcast('scroll.infiniteScrollComplete');
                        },
                        403: function (rejection) { // FORBIDDEN
                            if (configService.load().headers.Dispositivo){
                                $injector.get('message')({
                                    title: 'global.title.403',
                                    template: rejection.data.message
                                });
                            }else{
                                window.location.url = '#/home';
                            }
                            $rootScope.$broadcast('scroll.infiniteScrollComplete');
                        },
                        404: function (rejection) { // PAGE NOT FOUND
                            $injector.get('message')({
                                title: 'global.title.404',
                                template: 'mensagens.MSG-404'
                            });
                            $rootScope.$broadcast('scroll.infiniteScrollComplete');
                        },
                        408: function (rejection) { // TIMEOUT
                            $injector.get('message')({
                                title: 'global.title.408',
                                template: 'mensagens.MSG-408'
                            });
                            $rootScope.$broadcast('scroll.infiniteScrollComplete');
                        },
                        500: function (rejection) { // INTERNAL SERVER ERROR
                            $injector.get('message')({
                                title: 'global.title.500',
                                template: rejection.data.message
                            });
                            $rootScope.$broadcast('scroll.infiniteScrollComplete');
                        },
                    default: function (rejection) { // INTERNAL SERVER ERROR
                            $injector.get('message')({
                                title: 'global.title.default',
                                template: 'mensagens.MSG-1000'
                            });
                            $rootScope.$broadcast('scroll.infiniteScrollComplete');
                        }
                    };

                    if (responseInterceptors[rejection.status]) {
                        responseInterceptors[rejection.status](rejection);
                    }

                    return $q.reject(rejection);
                }
            }
        }]);

    $httpProvider.defaults.transformResponse.push(function (responseData) {
        convertDateStringsToDates(responseData);
        return responseData;
    });

    $httpProvider.defaults.transformRequest.splice(0, 0, function (requestData) {
        convertDateToStrings(requestData);
        return requestData;
    });
}

calvinApp.config(['$stateProvider', '$urlRouterProvider', '$httpProvider', 'RestangularProvider', '$translateProvider', '$ionicConfigProvider',
    function ($stateProvider, $urlRouterProvider, $httpProvider, RestangularProvider, $translateProvider, $ionicConfigProvider) {
        // Configurando interceptor de autenticação
        configureHttpInterceptors($httpProvider);

        $ionicConfigProvider.backButton.text('');

        // Configurando UI-ROUTER
        $urlRouterProvider.otherwise('/home');
        $stateProvider.state('site', {
            abstract: true,
            resolve: {
                translatePartialLoader: ['$translatePartialLoader', function ($translatePartialLoader) {
                        $translatePartialLoader.addPart('global');
                    }],
                mainTranslatePartialLoader: ['$translate', function ($translate) {
                        return $translate.refresh();
                    }]
            }
        });

        // Configuranto Restangular
        RestangularProvider.setBaseUrl($_serverUrl + '/rest');


        // Configurando o angular-translate
        $translateProvider.useLoader('$translatePartialLoader', {
            urlTemplate: 'i18n/{lang}/{part}.json'
        });

        $translateProvider.preferredLanguage('pt-br');
        $translateProvider.useMessageFormatInterpolation();
        $translateProvider.useSanitizeValueStrategy('escaped');
        $translateProvider.addInterpolation('$translateMessageFormatInterpolation');

        if (!$httpProvider.defaults.headers.get) {
            $httpProvider.defaults.headers.get = {};
        }
        // disable IE ajax request caching
        $httpProvider.defaults.headers.get['If-Modified-Since'] = 'Mon, 26 Jul 1997 05:00:00 GMT';
        $httpProvider.defaults.headers.get['Cache-Control'] = 'no-cache';
        $httpProvider.defaults.headers.get['Pragma'] = 'no-cache';
    }])

        .run(function ($rootScope, $state, acessoService, configService, $ionicViewService, $ionicPlatform, $ionicSideMenuDelegate) {
            var config = configService.load();
    $rootScope.usuario = config.usuario;
    $rootScope.funcionalidades = config.funcionalidades;
    $rootScope.funcionalidadesPublicas = config.funcionalidadesPublicas;

    if (!config.timeout){
        acessoService.buscaFuncionalidadesPublicas(function(funcionalidades){
            $rootScope.funcionalidadesPublicas = funcionalidades;
        });
    }

    $ionicPlatform.on("resume", function(){
        var time = new Date().getTime();

        if (!config.timeout || config.timeout < time) {
            acessoService.buscaFuncionalidadesPublicas(function(funcionalidades){
                $rootScope.funcionalidadesPublicas = funcionalidades;

                configService.save({
                    funcionalidadesPublicas: $rootScope.funcionalidadesPublicas,
                    timeout: time + 3600000
                });
                
                if (config.usuario && config.funcionalidades){
                    acessoService.carrega(function (acesso) {
                        $rootScope.usuario = acesso.membro;
                        $rootScope.funcionalidades = acesso.funcionalidades;

                        configService.save({
                            usuario: $rootScope.usuario,
                            funcionalidades: $rootScope.funcionalidades,
                            timeout: time + 3600000
                        });
                    });
                }
            });
        }
    });

    $rootScope.$on('$cordovaNetwork:online', function(event, networkState){
        $rootScope.offline = false;
    });

    $rootScope.$on('$cordovaNetwork:offline', function(event, networkState){
        $rootScope.offline = true;
    });

    $rootScope.logout = function () {
        var cb = function(){
            $rootScope.usuario = null;
            $rootScope.funcionalidades = null;
            configService.save({usuario: '', funcionalidades: '', headers: {Authorization: ''}});
            $ionicViewService.nextViewOptions({
                disableBack: true
            });
            $ionicSideMenuDelegate.toggleLeft();
            $state.go('login');
        };

        acessoService.logout(cb,function(response){
            if (response.status == 403){
                cb();
            }
        });
    };
})

        .factory('NodePushServer', function (acessoService) {
            return {
                storeDeviceToken: function (regId) {
                    acessoService.registerPushToken(regId);
        },
        removeDeviceToken: function (regId) {
            acessoService.unregisterPushToken(regId);
        }
    };
})

// PUSH NOTIFICATIONS
        .service('PushNotificationsService', function (message, NodePushServer, config, $rootScope, $cordovaNetwork, $state, $ionicViewService) {
            this.register = function (novaVersao) {
                if ($cordovaNetwork.isOnline()){
                    pushRegister(novaVersao);
        }else{
            var stop = $rootScope.$on('$cordovaNetwork:online', function(event, networkState){
                pushRegister(novaVersao);
                stop();
            });
        }
    };

    function pushRegister(novaVersao){
        var push = PushNotification.init({
            android:{
                senderID: $_gcmSenderId,
                icon: 'push'
            },
            ios:{
                badge: true,
                sound: true,
                alert: true
            }
        });

        if (novaVersao){
            push.on('registration', function(data){
                NodePushServer.storeDeviceToken({
                    token: data.registrationId,
                    version: config.version,
                    tipoDispositivo: config.tipo
                });
            });
        }


        push.on('notification', function(data){
            if (data.additionalData.foreground){
                message({title: data.title,template: data.message});
            }else if (data.additionalData.coldstart){
                $ionicViewService.nextViewOptions({
                    disableBack: true
                });
                $state.go('notificacao');
            }
        });
    }
});

var regexDateTime = /^\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}.+$/;
var regexDate = /^\d{4}\-\d{2}\-\d{2}$/;
var regexTime = /^\d{2}:\d{2}:\d{2}\.\d{3}/;

function convertDateStringsToDates(input) {
    // Ignore things that aren't objects.
    if (typeof input !== "object")
        return input;

    for (var key in input) {
        if (!input.hasOwnProperty(key))
            continue;

        var value = input[key];
        var match;
        // Check for string properties which look like dates.
        if (typeof value === "string" && (match = value.match(regexDateTime))) {
            input[key] = moment(match[0]).toDate('YYYY-MM-DDTHH:mm:ss.SSSZZ');
        }else if (typeof value === "string" && (match = value.match(regexDate))) {
            input[key] = moment(match[0]).toDate('YYYY-MM-DD');
        }else if (typeof value === "string" && (match = value.match(regexTime))) {
            input[key] = moment(match[0]).toDate('HH:mm:ss.SSS');
        } else if (typeof value === "object") {
            // Recurse into object
            convertDateStringsToDates(value);
        }
    }
}

function convertDateToStrings(input) {
    // Ignore things that aren't objects.
    if (typeof input !== "object")
        return input;

    for (var key in input) {
        if (!input.hasOwnProperty(key))
            continue;

        var value = input[key];
        // Check for string properties which look like dates.
        if (value instanceof Date) {
            input[key] = formatDate(value);
        } else if (typeof value === "object") {
            // Recurse into object
            convertDateStringsToDates(value);
        }
    }
}

function formatDate(date) {
    if (!date)
        return null;
    return moment(date).format('YYYY-MM-DDTHH:mm:ss.SSSZZ');
}


