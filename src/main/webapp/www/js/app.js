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
    'jett.ionic.filter.bar'
]).run(function ($ionicPlatform, PushNotificationsService, $rootScope, 
        $ionicConfig, $timeout, configService, $cordovaDevice, $state, boletimService, arquivoService) {


    $ionicPlatform.on("deviceready", function () {
        // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
        // for form inputs)
        if (window.cordova && window.cordova.plugins.Keyboard) {
            cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
        }
        if (window.StatusBar) {
            StatusBar.styleDefault();
        }
        
        configService.save({
            tipo: ionic.Platform.isAndroid() ? 0 : 1,
            headers:{
                Dispositivo: $cordovaDevice.getUUID()
            }
        });

        PushNotificationsService.register();
        
		arquivoService.init();
		
        boletimService.renovaCache();
        
        $state.reload();
    });

    // This fixes transitions for transparent background views
    $rootScope.$on("$stateChangeStart", function (event, toState, toParams, fromState, fromParams) {
        if (toState.name.indexOf('auth.walkthrough') > -1)
        {
            // set transitions to android to avoid weird visual effect in the walkthrough transitions
            $timeout(function () {
                $ionicConfig.views.transition('android');
                $ionicConfig.views.swipeBackEnabled(false);
                console.log("setting transition to android and disabling swipe back");
            }, 0);
        }
    });

    $rootScope.$on("$stateChangeSuccess", function (event, toState, toParams, fromState, fromParams) {
        if (toState.name.indexOf('app.feeds-categories') > -1)
        {
            // Restore platform default transition. We are just hardcoding android transitions to auth views.
            $ionicConfig.views.transition('platform');
            // If it's ios, then enable swipe back again
            if (ionic.Platform.isIOS())
            {
                $ionicConfig.views.swipeBackEnabled(true);
            }
            console.log("enabling swipe back and restoring transition to platform default", $ionicConfig.views.transition());
        }
    });

    $ionicPlatform.on("resume", function () {
        PushNotificationsService.register();
    });

}).value('config', {
    server: $_serverUrl,
    version: $_version,
    android: {
        gcmSenderId: $_gcmSenderId
    },
    ios: {
        name: $_serverCode
    },
    headers: {
        Igreja: $_serverCode
    }
}).service('configService', ['config', '$window', '$cordovaDevice', function (config, $window, $cordovaDevice) {
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
    }]).value('cache', {}).service('cacheService', ['$window', 'cache', function ($window, cache) {
        this.load = function () {
            if (!$window.localStorage.getItem('cache')) {
                this.save({});
            }

            return angular.extend(cache, angular.fromJson($window.localStorage.getItem('cache')));
        };

        this.save = function (che) {
            $window.localStorage.setItem('cache', angular.toJson(angular.extend(cache, che)));
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
        }]
            );

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

        $ionicConfigProvider.views.maxCache(0);

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
            },
            controller: ['$scope', function ($scope) {
                }]
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

        .run(function ($rootScope, $state, acessoService, configService, $ionicViewService, $cordovaNetwork, $ionicSideMenuDelegate) {
            var config = configService.load();
            $rootScope.usuario = config.usuario;
            $rootScope.funcionalidades = config.funcionalidades;
            
            if (config.headers['Authorization']) {
                acessoService.carrega(function (acesso) {
                    $rootScope.usuario = acesso.membro;
                    $rootScope.funcionalidades = acesso.funcionalidades;
                    configService.save({
                        usuario: $rootScope.usuario,
                        funcionalidades: $rootScope.funcionalidades
                    });
                });
            }
            
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
        .service('PushNotificationsService', function (message, NodePushServer, config) {
            this.register = function () {
                var push = PushNotification.init({
                    android:{
                        senderID: config.android.gcmSenderId,
                        icon: 'push',
                        iconColor: '#006fb7'
                    },
                    ios:{
                        badge: true,
                        sound: true,
                        alert: true
                    }
                });

                push.on('registration', function(data){
                        NodePushServer.storeDeviceToken({
                            token: data.registrationId,
                            version: config.version,
                            tipoDispositivo: config.tipo
                        });
                });

                push.on('notification', function(data){
                    if (data.additionalData.foreground){
                        message({title: data.title,template: data.message});
                    }
                });
            };
        });

var regexDate = /^\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}.+$/;

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
        if (typeof value === "string" && (match = value.match(regexDate))) {
            input[key] = moment(match[0]).toDate('YYYY-MM-DDTHH:mm:ss.SSSZZ');
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
