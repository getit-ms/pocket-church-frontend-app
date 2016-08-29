calvinApp.service('pdfService', ['cacheService', 'arquivoService', function(cacheService, arquivoService){
        this.get = function (req){
            cacheService.get(angular.extend({}, req, {
                callback:function(pdf){
                    for (var i = 0;i<pdf.paginas.length;i++){
                        trata(pdf.paginas[i]);
                    }
                    req.callback(pdf);
                }
            }));
        };
        
        function trata(pagina){
            arquivoService.get(pagina.id, function(data){
                pagina.localPath = data.file;
            });
        }
        
        this.load = function(chave, pdfs){
            for (var i=0;i<pdfs.length && i<5;i++){
                this.get(chave, pdfs[i].id, function(id, callback){
                    callback(pdfs[i]);
                });
            }
        };
    }]);
