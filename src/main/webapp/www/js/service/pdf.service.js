calvinApp.service('pdfService', ['$window', 'arquivoService', function($window, arquivoService){
        this.timeout = 1000 * 60 * 60 * 24 * 5;

        this.cache = function(chave, pdf, callback){
            if (!this.progressoCache(pdf)){
                var setCache = this.setCache;
                var getCache = this.getCache;
                var clearCache = this.clearCache;
                var cache = {paginas:[], timeout:new Date().getTime() + this.timeout};
                cache[chave] = pdf;
                setCache(chave, pdf.id, cache);

                var self = this;
                for (var i = 0;i<pdf.paginas.length;i++){
                    arquivoService.download(pdf.paginas[i].id, function(id, success){
                        self.trataPagina(chave, pdf, id, success, callback);
                    });
                }
            }
        };

        this.trataPagina = function(chave, pdf, id, success, callback){
            if (success){
                var cache = this.getCache(chave, pdf.id);
                if (cache && cache.paginas.indexOf(id) < 0){
                    cache.paginas.push(id);
                    this.setCache(chave, pdf.id, cache);

                    if (callback && cache.paginas.length == pdf.paginas.length){
                        callback(true);
                    }
                }
            }else{
                this.clearCache(chave, pdf.id);
                if (callback) callback(false);
            }
        };

        this.clearCacheAntigos = function(chave){
            for (i=0;i<$window.localStorage.length;i++){
                var key = $window.localStorage.key(i);
                if (key.startsWith(chave + '.')){
                    var id = key.replace(chave + '.', '');
                    var cache = this.getCache(chave, id);

                    if (cache){
                        if (cache.timeout < new Date().getTime()){
                            this.clearCache(chave, id);
                        }
                    }
                }
            }
        };

        this.getCache = function(chave, id){
            return angular.fromJson($window.localStorage.getItem(chave + '.' + id));
        };

        this.setCache = function(chave, id, cache){
            $window.localStorage.setItem(chave + '.' + id, angular.toJson(cache));
        };

        this.clearCache = function(chave, id){
            var cache = this.getCache(chave, id);

            if (cache){
                $window.localStorage.setItem(chave + '.' + id, null);
                for (var i=0;i<cache[chave].paginas.length;i++){
                    arquivoService.remove(cache[chave].paginas[i].id);
                }
            }
        };

        this.progressoCache = function(chave, pdf){
            var cache = this.getCache(chave, pdf.id);
            
            if (pdf){
                for (var i=0;i<cache.paginas.length;){
                    var pag = cache.paginas[i];
                    var index = -1;
                    
                    pdf.paginas.forEach(function(pagina, idx){
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
                pdf = cache[chave];
            }
            

            if (cache){
                return cache.paginas.length / pdf.paginas.length;
            }

            return 0;
        };

        this.carregaNovos = function(chave, pdfs){
            for (var i=0;i<pdfs.length && i<5;i++){
                if (!this.progressoCache(chave, pdfs[i])){
                    this.cache(chave, pdfs[i]);
                }
            }
        };
    }]);
