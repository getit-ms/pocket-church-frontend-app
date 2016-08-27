calvinApp.service('pdfService', ['cacheService', 'arquivoService', function(cacheService, arquivoService){
        this.get = function (chave, id, supplier){
            cacheService.get(chave, function(pdf){
                for (var i = 0;i<pdf.paginas.length;i++){
                    trata(pdf.paginas[i]);
                }
            }, supplier, id);
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
