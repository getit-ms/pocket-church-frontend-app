calvinApp.service('boletimService', ['Restangular', '$window', 'arquivoService', function(Restangular, $window, arquivoService){
        this.api = function(){
            return Restangular.one('boletim');
        };
        
        this.busca = function(filtro, callback){
            return this.api().all('publicados').get('', filtro).then(callback);
        };
        
        this.carrega = function(id){
            return this.api().one('' + id).get().$object;
        };
        
        this.timeout = 1000 * 60 * 60 * 24 * 5;
        
        this.cache = function(boletim, callback){
            if (this.progressoCache(boletim.id)){
                this.setCache(boletim.id, angular.toJson({boletim:boletim, paginas:0, timeout:new Date().getTime() + this.timeout}));
                for (var i = 0;i<boletim.paginas.length;i++){
                    arquivoService.download(boletim.paginas[i].id, function(){
                        var cache = this.getCache(boletim.id);
                        cache.paginas++;
                        this.setCache(boletim.id, cache);
                        
                        if (callback && cache.paginas == boletim.paginas.length){
                            callback(true);
                        }
                    }, function(){
                        callback(false);
                    });
                }
            }
        };
        
        this.clearCacheAntigos = function(){
            var keys = $window.localStorage.keys();
            for (i=0;i<keys.length;i++){
                if (keys[i].startsWith('boletim')){
                    var id = keys[i].replace('boletim', '');
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
            return JSON.parse($window.localStorage.getItem('boletim' + id));
        };
        
        this.setCache = function(id, cache){
            $window.localStorage.setItem('boletim' + id, angular.toJson(cache));
        };
        
        this.clearCache = function(id){
            var cache = this.getCache(id);
            
            if (cache){
                $window.localStorage.setItem('boletim' + id, null);
                for (var i=0;i<cache.boletim.paginas.length;i++){
                    arquivoService.remove(cache.boletim.paginas[i].id);
                }
            }
        };
        
        this.progressoCache = function(id){
            var cache = this.getCache(id);
            
            if (cache){
                return cache.paginas / cache.boletim.paginas.length;
            }
            
            return 0;
        };
        
        this.verificaNovos = function(){
            this.busca({pagina:1,total:10}, function(boletins){
                for (var i=0;i<boletins.resultados.length && i<5;i++){
                    if (!this.progressoCache(boletins.resultados[i].id)){
                        this.cache(boletins.resultados[i]);
                    }
                }
            });
        };
        
        this.renovaCache = function(){
            this.clearCacheAntigos();
            this.verificaNovos();
        };
}]);
        