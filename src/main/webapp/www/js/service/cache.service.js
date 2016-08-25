calvinApp.service('cacheService', ['$window', '$cordovaNetwork', 'message',
    function($window, $cordovaNetwork, message){
        this.timeout = 1000 * 60 * 60 * 24 * 5;
        
        this.get = function(chave, callback, supplier, id){
            if (!chave || !callback || !supplier) console.error("cacheService.single: chave, callback and supplier are required");
            
            var cache = load(chave, id);
            if (cache){
                cache.access = new Date().getTime();
                save(chave, id, cache);
                callback(cache.value);
            }
            
            try{
                if ($cordovaNetwork.isOnline()){
                    if (id) {
                        supplier(id, function(value){
                            save(chave, id, {access:new Date().getTime(),value:value});
                            callback(value);
                        });
                    }else{
                        supplier(function(value){
                            save(chave, id, {access:new Date().getTime(),value:value});
                            callback(value);
                        });
                    }
                }else if (!cache){
                    message({
                        title: 'global.title.404',
                        template: 'mensagens.MSG-404'
                    });
                }
            }catch (e){
                if (!cache){
                    message({
                        title: 'global.title.404',
                        template: 'mensagens.MSG-404'
                    });
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
                            remove(chave, id);
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
