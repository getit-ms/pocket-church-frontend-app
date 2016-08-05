calvinApp.service('boletimService', ['Restangular', '$window', 'arquivoService', function(Restangular, $window, arquivoService){
        this.api = function(){
            return Restangular.one('boletim');
        };
        
        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };
        
        this.carrega = function(id, callback){
            this.api().one('' + id).get().then(callback);
        };
        
        this.timeout = 1000 * 60 * 60 * 24 * 5;
        
        this.cache = function(boletim, callback){
            if (!this.progressoCache(boletim.id)){
                var setCache = this.setCache;
                var getCache = this.getCache;
                var clearCache = this.clearCache;
                setCache(boletim.id, {boletim:boletim, paginas:[], timeout:new Date().getTime() + this.timeout});
                var deveContinuar = true;
                for (var i = 0;deveContinuar && i<boletim.paginas.length;i++){
                    arquivoService.download(boletim.paginas[i].id, function(id){
                        var cache = getCache(boletim.id);
                        if (cache && cache.paginas.indexOf(id) < 0){
                            cache.paginas.push(id);
                            setCache(boletim.id, cache);
                            
                            if (callback && cache.paginas.length == boletim.paginas.length){
                                callback(true);
                            }
                        }
                    }, function(){
                        clearCache(boletim.id);
                        deveContinuar = false;
                        if (callback) callback(false);
                    });
                }
            }
        };
        
        this.clearCacheAntigos = function(){
            for (i=0;i<$window.localStorage.length;i++){
                var key = $window.localStorage.key(i);
                if (key.startsWith('boletim.')){
                    var id = key.replace('boletim.', '');
                    var cache = this.getCache(id);
                    
                    if (cache){
                        if (cache.timeout < new Date().getTime()){
                            this.clearCache(id);
                        }
                    }
                }
            }
        };
        
        this.getCache = function(id){
            return angular.fromJson($window.localStorage.getItem('boletim.' + id));
        };
        
        this.setCache = function(id, cache){
            $window.localStorage.setItem('boletim.' + id, angular.toJson(cache));
        };
        
        this.clearCache = function(id){
            var cache = this.getCache(id);
            
            if (cache){
                $window.localStorage.setItem('boletim.' + id, null);
                for (var i=0;i<cache.boletim.paginas.length;i++){
                    arquivoService.remove(cache.boletim.paginas[i].id);
                }
            }
        };
        
        this.progressoCache = function(id){
            var cache = this.getCache(id);
            
            if (cache){
                return cache.paginas.length / cache.boletim.paginas.length;
            }
            
            return 0;
        };
        
        this.verificaNovos = function(){		
            var self = this;
            this.busca({pagina:1,total:10}, function(boletins){
                self.carregaNovos(boletins);
            });
        };
        
        this.carregaNovos = function(boletins){
            for (var i=0;i<boletins.resultados.length && i<5;i++){
                if (!this.progressoCache(boletins.resultados[i].id)){
                    this.cache(boletins.resultados[i]);
                }
            }
        };
        
        this.renovaCache = function(){
            this.clearCacheAntigos();
            this.verificaNovos();
        };
    }]);