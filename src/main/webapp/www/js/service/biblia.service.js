calvinApp.service('bibliaService', ['Restangular', 'databaseService', function(Restangular, databaseService){
        this.api = function(){
            return Restangular.all('biblia');
        };
        
        this.sincroniza = function(){
            var api = this.api;
            databaseService.findUltimaAlteracaoLivroBiblia(function(ultimaAlteracao){
                var busca = function(page){
                    api.customGET('', {
                        ultimaAlteracao:ultimaAlteracao,
                        page:page,
                        total:1
                    }).then(function(livros){
                        livros.resultados.forEach(databaseService.mergeLivroBiblia);
                        
                        if (livros.hasProxima){
                            busca(page + 1);
                        }
                    });
                };
                
                busca(1);
            });
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
        