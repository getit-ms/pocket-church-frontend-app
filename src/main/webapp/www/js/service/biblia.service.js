calvinApp.service('bibliaService', ['Restangular', 'databaseService', function(Restangular, databaseService){
        this.api = function(){
            return Restangular.all('biblia');
        };

        this.sincronizacao = {porcentagem:100};

        this.sincroniza = function(){
            var api = this.api;
            var sincronizacao = this.sincronizacao;

            var busca = function(pagina, ultimaAtualizacao){
                var filtro = {
                    ultimaAtualizacao:ultimaAtualizacao,
                    pagina:pagina,
                    total:3
                };

                window.localStorage.setItem('filtro_incompleto_biblia', angular.toJson(filtro));

                sincronizacao.porcentagem = 0;

                api().customGET('', filtro).then(function(livros){
                    livros.resultados.forEach(databaseService.mergeLivroBiblia);

                    sincronizacao.porcentagem = 100 * livros.pagina / livros.totalPaginas;

                    if (livros.hasProxima){
                        busca(pagina + 1, ultimaAtualizacao);
                    }else{
                        window.localStorage.removeItem('filtro_incompleto_biblia');
                    }
                }, function(){
                    sincronizacao.porcentagem = 100;
                });
            };

            var filtro = window.localStorage.getItem('filtro_incompleto_biblia');

            if (filtro){
                busca(1, angular.fromJson(filtro).ultimaAtualizacao);
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
