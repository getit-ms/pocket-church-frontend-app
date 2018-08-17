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
  'chart.js',
  'angular-inview',
  'wu.masonry'
]).run(function ($ionicPlatform, PushNotificationsService, $rootScope, configService, notificacaoService, $cordovaLocalNotification,
                 arquivoService, cacheService, $cordovaNetwork, acessoService, boletimService, $cordovaBadge, $state, $ionicHistory,
                 database, $q, pdfService, playerService, hinoService, bibliaService, leituraService) {
  $rootScope.toggleMenu = function(menu) {
    if ($rootScope._menuSelecionado) {
      $rootScope._menuSelecionado.selecionado = false;
    }
    if ($rootScope._menuSelecionado != menu) {
      $rootScope._menuSelecionado = menu;
      $rootScope._menuSelecionado.selecionado = true;
    } else {
      $rootScope._menuSelecionado = undefined;
    }
  };

  playerService.init();

  $rootScope.$on( "$stateChangeSuccess", function( event, toState, toParams, fromState, fromParams ) {
    var body = angular.element(window.document.body);

    if (fromState && fromState.name) {
      body.removeClass( 'route-' + fromState.name.replace( /\./g, '-' ) );
    }

    body.addClass( 'route-' + toState.name.replace( /\./g, '-' ) );
  });

  $rootScope.localPath = function(arquivo){
    if (!arquivo) {
      return undefined;
    }

    if (!arquivo.localPath){
      arquivo.localPath = '#';
      arquivoService.get(arquivo.id, function(file){
        arquivo.localPath = file.file;
      }, function(file){
        arquivo.localPath = file.file;
      }, function(file){
        arquivo.localPath = file.file;
      });
    }

    return arquivo.localPath;
  };

  $rootScope.menuSelecionado = function(menu) {
    return menu.selecionado;
  };

  function carregaFuncionalidades(){
    var deferred = $q.defer();

    configService.load().then(function(config) {
      if (config.usuario){
        acessoService.carrega(function (acesso) {
          $rootScope.usuario = acesso.membro;
          $rootScope.carregaMenu(acesso.menu);

          configService.save({
            usuario: $rootScope.usuario,
            menu: $rootScope.menu
          });

          deferred.resolve();
        }, function(){
          deferred.reject();
        });
      }else{
        acessoService.buscaMenu(function(menu){
          $rootScope.carregaMenu(menu);

          configService.save({
            menu: $rootScope.menu
          });

          deferred.resolve();
        }, function(){
          deferred.reject();
        });
      }
    });

    return deferred.promise;
  }

  $rootScope.registerPush = function(force) {
    PushNotificationsService.register(force);
  };

  $ionicPlatform.on("resume", function(){
    $rootScope.offline = !$cordovaNetwork.isOnline();

    arquivoService.init();
    database.init();

    configService.load().then(function(config){
      $rootScope.usuario = config.usuario;
      $rootScope.carregaMenu(config.menu, true);

      $rootScope.registerPush(false);

      carregaFuncionalidades();
    });

  });

  $rootScope.funcionalidadeHabilitada = function(funcionalidade) {
    if ($rootScope.menu && $rootScope.menu.submenus) {
      for (var i=0;i<$rootScope.menu.submenus.length;i++) {
        var menu = $rootScope.menu.submenus[i];

        if (menu.funcionalidade == funcionalidade) {
          return true;
        }

        if (menu.submenus) {
          for (var j=0;j<menu.submenus.length;j++) {
            var submenu = menu.submenus[j];

            if (submenu.funcionalidade == funcionalidade) {
              return true;
            }
          }
        }
      }
    }

    return false;
  };

  var findMenu = function(mnus, match) {
    for (var i=0;i<mnus.length;i++){
      var mnu = mnus[i];
      if (match(mnu)) {
        return mnu;
      }
    }

    return undefined;
  };

  $rootScope.carregaMenu = function(menu, clearNotificacoes) {
    if (menu && menu.submenus) {
      var total = 0;

      angular.forEach(menu.submenus, function(mnu) {
        if (mnu.selecionado) {
          mnu.selecionado = undefined;
        }

        if (clearNotificacoes) {
          mnu.notificacoes = 0;
          if (mnu.submenus) {
            angular.forEach(mnu.submenus, function(sbm) {
              sbm.notificacoes = 0;
            });
          }
        }

        total += mnu.notificacoes || 0;
      });

      try {
        if (total) {
          $cordovaBadge.set(total);
        } else {
          $cordovaBadge.clear();
        }
      } catch (e) {
        console.error(e);
      }
    }

    if ($rootScope.menu && $rootScope.menu.submenus) {
      var selecionado = findMenu($rootScope.menu.submenus, function(mnu) {
        return mnu.selecionado;
      });

      if (selecionado && menu.submenus) {
        var aSelecionar = findMenu(menu.submenus, function(mnu) {
          return mnu.nome == selecionado.nome;
        });

        if (aSelecionar) {
          aSelecionar.selecionado = true;
          $rootScope._menuSelecionado = aSelecionar;
        } else{
          $rootScope._menuSelecionado = undefined;
        }
      } else {
        $rootScope._menuSelecionado = undefined;
      }
    }

    $rootScope.menu = menu;
  };

  $rootScope.initApp = function () {
    $rootScope.offline = !$cordovaNetwork.isOnline();

    arquivoService.init();
    pdfService.init();
    database.init();

    var next = { then: function(callback){ callback(); } };

    var execucoes = [
      function(){ return carregaFuncionalidades(); },
      function(){ return cacheService.clean(); },
      function(){ return arquivoService.clean(); },
      function(){ return pdfService.clean(); },
      function(){
        if ($rootScope.funcionalidadeHabilitada('BIBLIA')){
          return bibliaService.sincroniza();
        }

        return next;
      },
      function(){
        if ($rootScope.funcionalidadeHabilitada('CONSULTAR_HINARIO')){
          return hinoService.sincroniza();
        }

        return next;
      },
      function(){
        if ($rootScope.funcionalidadeHabilitada('LISTAR_BOLETINS')){
          return boletimService.cache();
        }

        return next;
      },
      function(){
        if ($rootScope.funcionalidadeHabilitada('CONSULTAR_PLANOS_LEITURA_BIBLICA')){
          return leituraService.sincroniza();
        }

        return next;
      }
    ];

    configService.load().then(function(config) {
      $rootScope.usuario = config.usuario;
      $rootScope.carregaMenu(config.menu, true);

      $rootScope.registerPush(false);

      if (!config.headers.Dispositivo || config.headers.Dispositivo === 'undefined'){
        configService.save({
          tipo: ionic.Platform.isAndroid() ? 0 : 1,
          headers:{
            Dispositivo: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
              var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
              return v.toString(16);
            })
          }
        }).then(function() {
          $rootScope.registerPush(false);

          $rootScope.deviceReady = true;
        });
      } else {
        $rootScope.registerPush(false);

        $rootScope.deviceReady = true;
      }

      executePilha(execucoes);
    });

  };

  $ionicPlatform.on("deviceready", function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }

    if (window.StatusBar && !ionic.Platform.isAndroid()) {
      if ($_statusBarLight) {
        StatusBar.styleLightContent();
      } else {
        StatusBar.styleDefault();
      }
    }

    $rootScope.initApp();
  });

}).factory('$exceptionHandler', ['$injector', function($injector) {

  var lastErrors = [];

  return function (exception, cause) {

    try {
      if (lastErrors.indexOf(exception.message) < 0) {
        lastErrors.push(exception.message);

        while (lastErrors.length > 5) {
          lastErrors.splice(0, 1);
        }

        ionic.Platform.ready(function() {
          try {
            var device = ionic.Platform.device();
            var usuario = $injector.get('$rootScope').usuario;

            $injector.get('chamadoService').cadastra({
              tipo: 'ERRO',
              descricao: 'Chamado automático de erro de interface: \n' +
              (device ? 'Dispositivo: ' + device.manufacturer + ' ' + device.model + ' ' + device.version + '\n' : '' ) +
              'Mensagem: ' + exception.message + '\n' +
              (cause ? 'Causa: ' + cause + '\n' : '') +
              'Stacktrace: ' + exception.stack,
              nomeSolicitante: 'Suporte GET IT - Chamado Automático',
              emailSolicitante: 'suporte@getitmobilesolutions.com'
            }, function(){});
          } catch (ex) {
            console.error(ex);
          }
        })
      }
    } catch (ex) {
      console.error(ex);
    }

    console.error(exception, cause);
  };
}]).service('loadingService', ['$ionicLoading', '$filter', '$rootScope', function($ionicLoading, $filter, $rootScope){
  this.show = function(dados){
    $rootScope.dadosLoading = dados;

    $ionicLoading.show({
      template:'<ion-spinner class="spinner-light"></ion-spinner><br/><br/>' + $filter('translate')('global.carregando')
      + '<div ng-if="dadosLoading.porcentagem">{{dadosLoading.porcentagem | number:0}}%</div>',
      animation: 'fade-in',
      scope: $rootScope
    });
  };

  this.hide = function(){
    $rootScope.dadosLoading = undefined;
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
    var deferred = $q.defer();

    var self = this;

    if (!self.config) {
      configDAO.get(function(config) {
        self.config = config || defaultConfig;

        deferred.resolve(self.config);
      });
    } else {
      configDAO.set(self.config);

      deferred.resolve(self.config);
    }

    return deferred.promise;
  };

  this.save = function (cfg) {
    var deferred = $q.defer();

    var self = this;

    this.load().then(function(config){

      self.config = angular.merge(config, cfg);

      configDAO.set(self.config);

      deferred.resolve(self.config);
    });

    return deferred.promise;
  };
}]);

function configureHttpInterceptors($httpProvider) {
  $httpProvider.interceptors.push(['$q', '$rootScope', 'backendErrors', 'configService', '$injector', 'database',
    function ($q, $rootScope, backendErrors, configService, $injector, database) {
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

          if (response.headers('Force-Reset')){
            database.resetAll();
            localStorage.clear();
            $rootScope.logout();
            $rootScope.initApp();
          } else if (response.headers('Force-Register')){
            configService.save({registrationId:'redefine'});

            if ($rootScope.registerPush) {
              $rootScope.registerPush(true);
            }
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
                angular.forEach(rejection.data.validations, function (erro) {
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

  .run(function ($rootScope, $state, acessoService, configService, $ionicHistory, $ionicSideMenuDelegate) {
    $rootScope.$on('$cordovaNetwork:online', function(event, networkState){
      $rootScope.offline = false;
    });

    $rootScope.$on('$cordovaNetwork:offline', function(event, networkState){
      $rootScope.offline = true;
    });

    $rootScope.logout = function () {
      var cb = function(){
        $rootScope.usuario = null;
        configService.save({usuario: '', menu: '', headers: {Authorization: ''}});

        acessoService.buscaMenu(function(menu) {
          $rootScope.carregaMenu(menu);

          configService.save({
            menu: $rootScope.menu
          });
        });

        $ionicHistory.nextViewOptions({
          disableBack: true
        });

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
  .service('PushNotificationsService', function (message, NodePushServer, $rootScope, $cordovaNetwork, $cordovaBadge, $state, $ionicHistory, configService) {
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

      push.on('registration', function(data){
        configService.load().then(function(config){
          if (config.headers.Dispositivo && (force ||
            $_version !== config.version ||
            data.registrationId !== config.registrationId)){

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
        try {
          if (data.additionalData.foreground){
            message({title: data.title,template: data.message});
          }else if (data.additionalData.coldstart){
            $ionicHistory.nextViewOptions({
              disableBack: true
            });
            $state.go('notificacao');
          } else if (data.badge) {
            $cordovaBadge.set(data.badge);
          } else {
            $cordovaBadge.clear();
          }
        } catch (e) {
          console.error(e);
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
