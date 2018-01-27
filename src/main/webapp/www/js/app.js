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
  'youtube-embed',
  'ion-gallery'
]).run(function ($ionicPlatform, PushNotificationsService, $rootScope, configService, notificacaoService, $cordovaLocalNotification,
                 arquivoService, cacheService, acessoService, boletimService, $cordovaBadge, bibliaService, database, hinoService, leituraService, $q) {
  function countNotificacoes(){
    var deferred = $q.defer();
    notificacaoService.count(function(dados){
      $rootScope.notifications = dados.count;
      $cordovaBadge.set(dados.count);
      deferred.resolve();
    }, function(){
      deferred.reject();
    });
    return deferred.promise;
  }

  function carregaFuncionalidades(){
    var deferred = $q.defer();

    countNotificacoes();

    $cordovaLocalNotification.clearAll();

    acessoService.buscaFuncionalidadesPublicas(function(funcionalidades){
      $rootScope.funcionalidadesPublicas = funcionalidades;

      configService.save({
        funcionalidadesPublicas: $rootScope.funcionalidadesPublicas
      });

      configService.load().then(function(config) {
        if (config.usuario && config.funcionalidades){
          acessoService.carrega(function (acesso) {
            $rootScope.usuario = acesso.membro;
            $rootScope.funcionalidades = acesso.funcionalidades;

            configService.save({
              usuario: $rootScope.usuario,
              funcionalidades: $rootScope.funcionalidades
            });

            deferred.resolve();
          }, function(){
            deferred.reject();
          });
        }else{
          deferred.reject();
        }
      });

    }, function(){
      deferred.reject();
    });

    return deferred.promise;
  }

  $ionicPlatform.on("resume", function(){
    arquivoService.init();
    database.init();

    configService.load().then(function(config){
      $rootScope.usuario = config.usuario;
      $rootScope.funcionalidades = config.funcionalidades;
      $rootScope.funcionalidadesPublicas = config.funcionalidadesPublicas;
    });

    carregaFuncionalidades();
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

    arquivoService.init();
    database.init();

    configService.save({
      tipo: ionic.Platform.isAndroid() ? 0 : 1
    });

    var next = { then: function(callback){ callback(); } };

    var execucoes = [
      function(){ return carregaFuncionalidades(); },
      function(){ return cacheService.clean(); },
      function(){ return arquivoService.clean(); },
      function(){
        if ($rootScope.funcionalidadesPublicas &&
          $rootScope.funcionalidadesPublicas.indexOf('BIBLIA') >= 0){
          return bibliaService.sincroniza();
        }

        return next;
      },
      function(){
        if ($rootScope.funcionalidadesPublicas &&
          $rootScope.funcionalidadesPublicas.indexOf('CONSULTAR_HINARIO') >= 0){
          return hinoService.sincroniza();
        }

        return next;
      },
      function(){
        if ($rootScope.funcionalidadesPublicas &&
          $rootScope.funcionalidadesPublicas.indexOf('LISTAR_BOLETINS') >= 0){
          return boletimService.cache();
        }

        return next;
      },
      function(){
        if ($rootScope.funcionalidades &&
          $rootScope.funcionalidades.indexOf('CONSULTAR_PLANOS_LEITURA_BIBLICA') >= 0){
          return leituraService.sincroniza();
        }

        return next;
      }
    ];

    configService.load().then(function(config) {
      if (!config.headers.Dispositivo || config.headers.Dispositivo === 'undefined'){
        configService.save({
          headers:{
            Dispositivo: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
              var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
              return v.toString(16);
            })
          }
        });
      }

      PushNotificationsService.register(false);

      $rootScope.deviceReady = true;

      executePilha(execucoes);
    });

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
  version: '0.0.0',
  ios: {
    name: $_serverCode
  },
  headers: {
    Igreja: $_serverCode,
    Dispositivo: 'undefined'
  }
}).service('configService', ['config', 'configDAO', '$window', '$q', function (defaultConfig, configDAO, $window, $q) {

  this.load = function () {
    var cfg = $window.localStorage.getItem('config');

    var deferred = $q.defer();

    if (!cfg) {
      configDAO.get(function(config) {
        var finalConfig = config || defaultConfig;

        $window.localStorage.setItem('config', angular.toJson(finalConfig));

        deferred.resolve(finalConfig);
      });
    } else {
      var config = angular.fromJson(cfg);

      configDAO.set(config);

      deferred.resolve(config);
    }

    return deferred.promise;
  };

  this.save = function (cfg) {
    var deferred = $q.defer();

    this.load().then(function(config){

      var merged = angular.merge(config, cfg);

      $window.localStorage.setItem('config', angular.toJson(merged));

      configDAO.set(merged);

      deferred.resolve(merged);
    });

    return deferred.promise;
  };
}]);

function configureHttpInterceptors($httpProvider) {
  $httpProvider.interceptors.push(['$q', '$rootScope', 'backendErrors', 'configService', '$injector', 'PushNotificationsService', 'database',
    function ($q, $rootScope, backendErrors, configService, $injector, PushNotificationsService, databse) {
      return {
        request: function (request) {
          var deferred = $q.defer();

          if (request.method === 'DELETE') {
            request.headers['Content-Length'] = 0;
            request.headers['Content-Type'] = 'application/json;charset=UTF-8';
            request.data = '';
          }

          configService.load().then(function(config){
            angular.extend(request.headers, config.headers);

            deferred.resolve(request);
          });

          return deferred.promise;
        },
        response: function(response){
          if (response.headers('Set-Authorization')){
            configService.save({headers:{Authorization:response.headers('Set-Authorization')}});
          }

          if (response.headers('Force-Register')){
            PushNotificationsService.register(true);
          }

          if (response.headers('Force-Reset')){
            database.resetAll();
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
              $injector.get('message')({
                title: 'global.title.403',
                template: rejection.data.message
              });
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

calvinApp.
run(['$translatePartialLoader', function($translatePartialLoader){
  $translatePartialLoader.addPart('global');
}]).
config(['$stateProvider', '$urlRouterProvider', '$httpProvider', 'RestangularProvider', '$translateProvider', '$ionicConfigProvider',
  function ($stateProvider, $urlRouterProvider, $httpProvider, RestangularProvider, $translateProvider, $ionicConfigProvider) {
    // Configurando interceptor de autenticação
    configureHttpInterceptors($httpProvider);

    $ionicConfigProvider.backButton.text('');

    // Configurando UI-ROUTER
    $urlRouterProvider.otherwise('/home');
    $stateProvider.state('site', {
      abstract: true,
      resolve: {
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

  .run(function ($rootScope, $state, acessoService, configService, $ionicViewService, $ionicSideMenuDelegate) {
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
      storeDeviceToken: function (registration, callback) {
        acessoService.registerPushToken(registration, callback);
      }
    };
  })

  // PUSH NOTIFICATIONS
  .service('PushNotificationsService', function (message, NodePushServer, $rootScope, $cordovaNetwork, $cordovaBadge, $state, $ionicViewService, configService) {
    this.register = function (force) {
      if ($cordovaNetwork.isOnline()){
        pushRegister(force);
      }else{
        var stop = $rootScope.$on('$cordovaNetwork:online', function(event, networkState){
          pushRegister(force);
          stop();
        });
      }
    };

    function pushRegister(force){
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

      configService.load().then(function(config){
        push.on('registration', function(data){
          if (force || $_version !== config.version ||
            data.registrationId !== config.registrationId){

            NodePushServer.storeDeviceToken({
              token: data.registrationId,
              version: $_version,
              tipoDispositivo: config.tipo
            }, function(){
              configService.save({
                version: $_version,
                registrationId: data.registrationId
              });
            });
          }
        });
      });

      push.on('notification', function(data){
        if (data.additionalData.foreground){
          message({title: data.title,template: data.message});
        }else if (data.additionalData.coldstart){
          $ionicViewService.nextViewOptions({
            disableBack: true
          });
          $state.go('notificacao');
        }else if (data.badge) {
          $cordovaBadge.set(data.badge);
          $rootScope.notifications = data.badge;
        }
      });
    }
  });

var regexDateTime = /^\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}.+$/;
var regexDate = /^\d{4}\-\d{2}\-\d{2}$/;
var regexTime = /^\d{2}:\d{2}:\d{2}\.\d{3}.+$/;

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
      input[key] = moment(match[0]).toDate('HH:mm:ss.SSSZZ');
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

function executePilha(execucoes){
  var idx = -1;

  function exec(){
    idx++;
    if (execucoes.length > idx){
      execucoes[idx]().then(exec, exec);
    }
  }

  exec();
}
