calvinApp.
  value('sincronizacaoHino', {porcentagem:0,executando:false}).
  service('hinoService', ['Restangular', 'sincronizacaoHino', 'hinoDAO', function(Restangular, sincronizacaoHino, hinoDAO){
        this.api = function(){
            return Restangular.all('hino');
        };

        this.sincroniza = function(){
            var api = this.api;
            var busca = function(pagina, ultimaAtualizacao){
                var filtro = {
                    ultimaAtualizacao: ultimaAtualizacao,
                    pagina:pagina,
                    total:10
                };

                window.localStorage.setItem('filtro_incompleto_hino', angular.toJson(filtro));
                sincronizacaoHino.executando = true;

                api().customGET('', filtro).then(function(hinos){
                    if (hinos.resultados){
                        hinos.resultados.forEach(hinoDAO.mergeHino);
                        sincronizacaoHino.porcentagem = Math.ceil(100 * hinos.pagina / hinos.totalPaginas);
                    }

                    if (hinos.hasProxima){
                        busca(pagina + 1, ultimaAtualizacao);
                    }else{
                        sincronizacaoHino.executando = false;
                        window.localStorage.removeItem('filtro_incompleto_hino');
                    }
                }, function(){
                    sincronizacaoHino.executando = false;
                });
            };

            var filtro = window.localStorage.getItem('filtro_incompleto_hino');

            if (filtro){
                var ofiltro = angular.fromJson(filtro);
                busca(ofiltro.pagina, ofiltro.ultimaAtualizacao);
            }else{
                hinoDAO.findUltimaAlteracaoHinos(function(ultimaAtualizacao){
                    busca(1, formatDate(ultimaAtualizacao));
                });
            }
        };
        
        this.incompleto = function(){
            return window.localStorage.getItem('filtro_incompleto_hino');
        };

        this.busca = function(filtro){
            return hinoDAO.findHinosByFiltro(filtro);
        };

        this.carrega = function(id){
            return hinoDAO.findHino(id);
        };
}]);
