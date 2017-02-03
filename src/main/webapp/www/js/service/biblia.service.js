calvinApp.
  value('sincronizacaoBiblia', {porcentagem:0,executando:false}).
  service('bibliaService', ['Restangular', 'bibliaDAO', 'sincronizacaoBiblia', function(Restangular, bibliaDAO, sincronizacaoBiblia){
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
                    livros.resultados.forEach(bibliaDAO.mergeLivroBiblia);

                    sincronizacaoBiblia.porcentagem = Math.ceil(100 * livros.pagina / livros.totalPaginas);

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
                bibliaDAO.findUltimaAlteracaoLivroBiblia(function(ultimaAtualizacao){
                    busca(1, formatDate(ultimaAtualizacao));
                });
            }
        };

        this.buscaLivros = function(testamento){
            return bibliaDAO.findLivrosBibliaByTestamento(testamento);
        };

        this.buscaLivro = function(livro){
            return bibliaDAO.findLivroBiblia(livro);
        };

        this.buscaCapitulos = function(livro){
            return bibliaDAO.findCapitulosLivroBiblia(livro);
        };

        this.buscaVersiculos = function(livro, capitulo){
            return bibliaDAO.findVersiculosByLivroCapituloBiblia(livro, capitulo);
        };
}]);
