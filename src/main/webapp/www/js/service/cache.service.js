calvinApp.service('cacheService', ['$window', '$cordovaNetwork', 'message', '$state', '$ionicHistory', '$rootScope', '$q',
    function($window, $cordovaNetwork, message, $state, $ionicHistory, $rootScope, $q){
        this.timeout = 1000 * 60 * 60 * 24 * 5;

        this.get = function(req){
            if (!req.chave || !req.callback || !req.supplier) console.error("cacheService.single: req.chave, req.callback and req.supplier are required");

            if (!$rootScope.deviceReady){
                if (req.id){
                    req.supplier(req.id, req.callback);
                }else{
                    req.supplier(req.callback);
                }
                return;
            }

            var cache = null;

            try{
                cache = load(req.chave, req.id);
                if (cache){
                    cache.access = new Date().getTime();
                    save(req.chave, req.id, cache);
                    req.callback(cache.value);
                    if (req.cachePriority) return;
                }
            }catch(e){
                console.error(e);
            }

            try{
                if ($cordovaNetwork.isOnline()){
                    if (req.id) {
                        req.supplier(req.id, function(value){
                            cache = {access:new Date().getTime(),value:value};
                            req.callback(value);
                            save(req.chave, req.id, cache);
                        });
                    }else{
                        req.supplier(function(value){
                            cache = {access:new Date().getTime(),value:value};
                            req.callback(value);
                            save(req.chave, req.id, cache);
                        });
                    }
                }else if (!cache){
                    message({
                        title: 'global.title.404',
                        template: 'mensagens.MSG-404'
                    });
                    if (req.errorState){
                        $ionicHistory.nextViewOptions({
                            historyRoot: true,
                            disableBack: true
                        });
                        $state.go(req.errorState);
                    }
                }
            }catch (e){
                if (!cache){
                    message({
                        title: 'global.title.404',
                        template: 'mensagens.MSG-404'
                    });
                    if (req.errorState){
                        $ionicHistory.nextViewOptions({
                            historyRoot: true,
                            disableBack: true
                        });
                        $state.go(req.errorState);
                    }
                }
                console.error(e);
            }
        };

        this.clean = function(){
            var deferred = $q.defer();

            try{
                var now = new Date().getTime();
                for (i=0;i<$window.localStorage.length;i++){
                    var key = $window.localStorage.key(i);
                    if (key.indexOf('cache.') === 0){
                        var cache = angular.fromJson($window.localStorage.getItem(key));

                        if (cache){
                            if (!cache.access || cache.access + this.timeout < now){
                                $window.localStorage.removeItem(key);
                            }
                        }
                    }
                }
                deferred.resolve();
            }catch(e){
                console.log(e);
                deferred.reject();
            }

            return deferred.promise;
        };

        function load(chave, id){
            if (id){
                return angular.fromJson($window.localStorage.getItem('cache.' + chave + '.' + id));
            }

            return angular.fromJson($window.localStorage.getItem('cache.' + chave));
        }

        function save(chave, id, cache){
            if (id){
                $window.localStorage.setItem('cache.' + chave + '.' + id, angular.toJson(cache));
            }else{
                $window.localStorage.setItem('cache.' + chave, angular.toJson(cache));
            }
        }

        function remove(chave, id){
            if (id){
                $window.localStorage.removeItem('cache.' + chave + '.' + id);
            }else{
                $window.localStorage.removeItem('cache.' + chave);
            }
        }
    }]);
