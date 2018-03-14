calvinApp.service('pdfService', ['cacheService', 'arquivoService', function(cacheService, arquivoService){
        this.get = function (req){
            cacheService.get(angular.extend({}, req, {
                callback:function(pdf){
                    var i=0;
                    var iniciado = 0;

                    function chamada(pagina){

                      if ((iniciado - i) <= 5) {
                        iniciado++;

                        trata(pagina, function(){
                          i++;

                          if (req.pagina) {
                            req.pagina(i, pdf.paginas.length);
                          }

                          if (i >= pdf.paginas.length){
                            req.callback(pdf);
                          }
                        });
                      } else {
                        setTimeout(function() {
                          chamada(pagina);
                        }, 50);
                      }
                    };

                    pdf.paginas.forEach(chamada);
                }
            }));
        };

        function trata(pagina, callback){
            arquivoService.get(pagina.id, function(data){
                pagina.src = data.file;
                callback();
            }, function(){
            }, function(data){
                pagina.src = data.file;
                callback();
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
