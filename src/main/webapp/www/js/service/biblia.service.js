calvinApp.
  value('sincronizacaoBiblia', {porcentagem:0,executando:false}).
  service('bibliaService', ['Restangular', 'databaseService', 'sincronizacaoBiblia', function(Restangular, databaseService, sincronizacaoBiblia){
        this.api = function(){
            return Restangular.all('biblia');
        };

        this.sincroniza = function(){
            var api = this.api;
            var busca = function(pagina, ultimaAtualizacao){
                var filtro = angular.extend({
                    ultimaAtualizacao:ultimaAtualizacao,
                    pagina:pagina,
                    total:3
                });

                window.localStorage.setItem('filtro_incompleto_biblia', angular.toJson(filtro));
                sincronizacaoBiblia.executando = true;

                api().customGET('', filtro).then(function(livros){
                    livros.resultados.forEach(databaseService.mergeLivroBiblia);

                    sincronizacaoBiblia.porcentagem = 100 * livros.pagina / livros.totalPaginas;

                    if (livros.hasProxima){
                        busca(pagina + 1, ultimaAtualizacao);
                    }else{
                        sincronizacaoBiblia.executando = false;
                        window.localStorage.removeItem('filtro_incompleto_biblia');
                    }
                }, function(){
                    sincronizacaoBiblia.executando = false;
                });
            };

            var filtro = window.localStorage.getItem('filtro_incompleto_biblia');

            if (filtro){
                var ofiltro = angular.fromJson(filtro);
                busca(ofiltro.pagina, ofiltro.ultimaAtualizacao);
            }else{
                databaseService.findUltimaAlteracaoLivroBiblia(function(ultimaAtualizacao){
                    busca(1, formatDate(ultimaAtualizacao));
                });
            }
        };

        this.buscaLivros = function(testamento){
            return databaseService.findLivrosBibliaByTestamento(testamento);
        };

        this.buscaLivro = function(livro){
            return databaseService.findLivroBiblia(livro);
        };

        this.buscaCapitulos = function(livro){
            return databaseService.findCapitulosLivroBiblia(livro);
        };

        this.buscaVersiculos = function(livro, capitulo){
            return databaseService.findVersiculosByLivroCapituloBiblia(livro, capitulo);
        };
}]);
