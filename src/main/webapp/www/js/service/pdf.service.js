calvinApp.service('pdfService', ['cacheService', 'arquivoService', function(cacheService, arquivoService){
        this.get = function (chave, id, supplier){
            cacheService.get(chave, id, function(pdf){
                for (var i = 0;i<pdf.paginas.length;i++){
                    arquivoService.get(pdf.paginas[i].id, function(data){
                        pdf.paginas[i].localPath = data.file;
                    });
                }
            }, supplier);
        };
        
        this.load = function(chave, pdfs){
            for (var i=0;i<pdfs.length && i<5;i++){
                this.get(chave, pdfs[i].id, function(id, callback){
                    callback(pdfs[i]);
                });
            }
        };
    }]);
