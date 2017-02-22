calvinApp.
        value('sincronizacaoLeitura', {porcentagem:0,executando:false}).
        service('leituraService', ['Restangular', 'sincronizacaoLeitura', 'leituraDAO', function(Restangular, sincronizacaoLeitura, leituraDAO){
        this.api = function(){
            return Restangular.all('planoLeitura');
        };

        this.sincroniza = function(){
            var api = this.api;
            
            var atualizaLeitura = this.atualizaLeitura;
            
            var busca = function(pagina, ultimaAtualizacao){
                var filtro = {
                    ultimaAtualizacao: ultimaAtualizacao,
                    pagina:pagina,
                    total:10
                };

                window.localStorage.setItem('filtro_incompleto_leitura', angular.toJson(filtro));
                sincronizacaoLeitura.executando = true;

                api().one('leitura').customGET('', filtro).then(function(leituras){
                    if (leituras.resultados){
                        leituras.resultados.forEach(leituraDAO.merge);
                        sincronizacaoLeitura.porcentagem = Math.ceil(100 * leituras.pagina / leituras.totalPaginas);
                    }

                    if (leituras.hasProxima){
                        busca(pagina + 1, ultimaAtualizacao);
                    }else{
                        leituraDAO.findNaoSincronizados().then(function(leituras){
                            leituras.forEach(function(leitura){
                                atualizaLeitura(leitura.dia.id, leitura.lido);
                            });
                            
                            sincronizacaoLeitura.executando = false;
                            window.localStorage.removeItem('filtro_incompleto_leitura');
                        });
                    }
                }, function(){
                    sincronizacaoLeitura.executando = false;
                });
            };

            var filtro = window.localStorage.getItem('filtro_incompleto_leitura');

            if (filtro){
                var ofiltro = angular.fromJson(filtro);
                busca(ofiltro.pagina, ofiltro.ultimaAtualizacao);
            }else{
                leituraDAO.findUltimaAlteracao(function(ultimaAtualizacao){
                    busca(1, formatDate(ultimaAtualizacao));
                });
            }
        };
        
        this.incompleto = function(){
            return window.localStorage.getItem('filtro_incompleto_leitura');
        };
        
        this.selecionaPlano = function(plano, success, error){
            this.api().one('leitura/' + plano).put().then(success, error);
        };

        this.findRangeDatas = function(){
            return leituraDAO.findRangeDatas();
        };

        this.findByData = function(data){
            return leituraDAO.findByData(data);
        };

        this.atualizaLeitura = function(id, lido){
            var api = this.api;
            
            leituraDAO.atualizaLeitura(id, lido ? true : false, function(){
                if (lido){
                    api().one('leitura/dia/' + id).put().then(function(){
                        leituraDAO.atualizaSincronizacao(id, true);
                    }, function(){
                        leituraDAO.atualizaSincronizacao(id, false);
                    });
                }else{
                    api().one('leitura/dia/' + id).remove().then(function(){
                        leituraDAO.atualizaSincronizacao(id, true);
                    }, function(){
                        leituraDAO.atualizaSincronizacao(id, false);
                    });
                }
            });
        };
        
        this.findPorcentagem = function(callback){
            leituraDAO.findPorcentagem().then(callback);
        };
        
        this.buscaDatasLidas = function(callback){
            leituraDAO.findDatasLidas().then(callback);
        };
        
        this.findPlanosDisponiveis = function(filtro, callback){
            this.api().customGET('', filtro).then(callback);
        };
    }]);
