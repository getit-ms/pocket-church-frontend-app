calvinApp.
        value('sincronizacaoHino', {porcentagem:0,executando:false}).
        service('hinoService', ['Restangular', 'sincronizacaoHino', 'hinoDAO', '$q', function(Restangular, sincronizacaoHino, hinoDAO, $q){
                this.api = function(){
                    return Restangular.all('hino');
        };

        this.sincroniza = function(){
            var deferred = $q.defer();

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
                        angular.forEach(hinos.resultados, hinoDAO.mergeHino);
                        sincronizacaoHino.porcentagem = Math.ceil(100 * hinos.pagina / hinos.totalPaginas);
                    }

                    if (hinos.hasProxima){
                        busca(pagina + 1, ultimaAtualizacao);
                    }else{
                        sincronizacaoHino.executando = false;
                        window.localStorage.removeItem('filtro_incompleto_hino');
                        deferred.resolve();
                    }
                }, function(){
                    sincronizacaoHino.executando = false;
                    deferred.reject();
                });
            };

            var filtro = window.localStorage.getItem('filtro_incompleto_hino');

            try{
                if (filtro){
                    var ofiltro = angular.fromJson(filtro);
                    busca(ofiltro.pagina, ofiltro.ultimaAtualizacao);
                }else{
                    hinoDAO.findUltimaAlteracaoHinos(function(ultimaAtualizacao){
                        busca(1, formatDate(ultimaAtualizacao));
                    });
                }
            }catch(e){
                console.log(e);
                deferred.reject();
            }

            return deferred.promise;
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
