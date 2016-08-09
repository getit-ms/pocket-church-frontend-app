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
                
                var self = this;
                for (var i = 0;i<boletim.paginas.length;i++){
                    arquivoService.download(boletim.paginas[i].id, function(id, success){
                        self.trataPagina(boletim, id, success, callback);
                    });
                }
            }
        };
		
        this.trataPagina = function(boletim, id, success, callback){
            if (success){
                var cache = this.getCache(boletim.id);
                if (cache && cache.paginas.indexOf(id) < 0){
                    cache.paginas.push(id);
                    this.setCache(boletim.id, cache);

                    if (callback && cache.paginas.length == boletim.paginas.length){
                        callback(true);
                    }
                }
            }else{
                this.clearCache(boletim.id);
                if (callback) callback(false);
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
        
        this.progressoCache = function(id, boletim){
            var cache = this.getCache(id);
            
            if (cache){
                if (boletim){
                    for (var i=0;i<cache.paginas.length;){
                        var pag = cache.paginas[i];
                        var index = -1;

                        boletim.paginas.forEach(function(pagina, idx){
                            if (pagina.id == pag){
                                index = idx;
                            }
                        });

                        if (index < 0){
                            arquivoService.remove(pag);
                            cache.paginas.splice(i, 1);
                        }else{
                            i++;
                        }
                    }
                }else{
                    boletim = cache.boletim;
                }
                
                return cache.paginas.length / boletim.paginas.length;
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
