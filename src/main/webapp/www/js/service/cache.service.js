calvinApp.service('cacheService', ['$window', '$cordovaNetwork', 'message', '$state', '$ionicViewService',
    function($window, $cordovaNetwork, message, $state, $ionicViewService){
        this.timeout = 1000 * 60 * 60 * 24 * 5;
        
        this.get = function(req){
            if (!req.chave || !req.callback || !req.supplier) console.error("cacheService.single: req.chave, req.callback and req.supplier are required");
            
            var cache = load(req.chave, req.id);
            if (cache){
                cache.access = new Date().getTime();
                save(req.chave, req.id, cache);
                req.callback(cache.value);
            }
            
            try{
                if ($cordovaNetwork.isOnline()){
                    if (req.id) {
                        req.supplier(req.id, function(value){
                            save(req.chave, req.id, {access:new Date().getTime(),value:value});
                            req.callback(value);
                        });
                    }else{
                        req.supplier(function(value){
                            save(req.chave, req.id, {access:new Date().getTime(),value:value});
                            req.callback(value);
                        });
                    }
                }else if (!cache){
                    message({
                        title: 'global.title.404',
                        template: 'mensagens.MSG-404'
                    });
                    if (req.errorState){
                        $ionicViewService.nextViewOptions({
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
                        $ionicViewService.nextViewOptions({
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
            var now = new Date().getTime();
            for (i=0;i<$window.localStorage.length;i++){
                var key = $window.localStorage.key(i);
                if (key.startsWith('cache.')){
                    var cache = $window.localStorage.getItem(key);

                    if (cache){
                        if (cache.access + this.timeout < now){
                            $window.localStorage.removeItem(key);
                        }
                    }
                }
            }
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
