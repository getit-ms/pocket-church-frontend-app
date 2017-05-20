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
                pagina.src = data.file;
            });
        }
        
        this.load = function(chave, pdfs){
            try{
                for (var i=0;i<pdfs.length && i<5;i++){
                    var pdf = pdfs[i];
                    arquivoService.get(pdf.thumbnail.id, function(){});
                    this.get({
                        chave: chave,
                        id: pdf.id,
                        supplier: function(id, callback){
                            callback(pdf);
                        },
                        callback: function(){}
                    });
                }
            }catch(e){}
        };
    }]);
