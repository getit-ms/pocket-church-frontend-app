calvinApp.config(['$stateProvider', function($stateProvider){
    $stateProvider.state('votacao', {
        parent: 'site',
        url: '/votacao',
        views:{
            'content@':{
                templateUrl: 'js/votacao/votacao.list.html',
                controller: function(votacaoService, $state, $scope){
                    $scope.searcher = function(page, callback){
                        votacaoService.busca({pagina:page,total:10}, callback);
                    };

                    $scope.votar = function(votacao){
                      if (votacao.respondido) {
                        message({title: 'global.title.403',template: 'mensagens.MSG-054'});
                      } else if (votacao.encerrado) {
                        $state.go('votacao.resultado', {id: votacao.id});
                      } else {
                        $state.go('votacao.votar', {id: votacao.id});
                      }
                    };

                    $scope.$on('$ionicView.enter', function(){
                        $scope.$broadcast('pagination.search');
                    });
                }
            }
        }
    }).state('votacao.votar', {
      parent: 'site',
      url: '/votacao/:id',
      views:{
        'content@':{
          templateUrl: 'js/votacao/votacao.form.html',
          controller: function(votacaoService, $scope, $stateParams, message, $ionicHistory){
            $scope.clear = function(){
              votacaoService.carrega($stateParams.id, function(votacao){
                $scope.resposta = {
                  votacao: votacao,
                  respostas: []
                };

                votacao.questoes.forEach(function(questao){
                  var respQuestao = {
                    questao: questao,
                    selections: []
                  };

                  $scope.resposta.respostas.push(respQuestao);

                  for (var i=0;i<questao.quantidadeVotos;i++){
                    respQuestao.selections.push({value:null});
                  }
                });

                $scope.proximo();
              });

              $scope.index = -1;
            };

            $scope.hasProximo = function(){
              return $scope.resposta && $scope.index < $scope.resposta.respostas.length - 1;
            };

            $scope.proximo = function(){
              if ($scope.hasProximo()){
                $scope.index++;
                $scope.questao = $scope.resposta.respostas[$scope.index];
              }
            };

            $scope.conclui = function(){
              if (!$scope.hasProximo()){
                votacaoService.submete($scope.parse($scope.resposta), function(){
                  message({title: 'global.title.200',template: 'mensagens.MSG-001'});
                  $ionicHistory.goBack();
                });
              }
            };

            $scope.parse = function(original){
              var parsed = angular.merge({votacao:original.votacao,respostas:[]});

              original.respostas.forEach(function(respQuestao){
                var respParsed = {questao:respQuestao.questao,opcoes:[]};

                respQuestao.selections.forEach(function(selection){
                  respParsed.opcoes.push({opcao:selection.value});
                });

                parsed.respostas.push(respParsed);
              });

              return parsed;
            };

            $scope.hasAnterior = function(){
              return $scope.index > 0;
            };

            $scope.anterior = function(){
              if ($scope.hasAnterior()){
                $scope.index--;
                $scope.questao = $scope.resposta.respostas[$scope.index];
              }
            };

            $scope.clear();
          }
        }
      }
    }).state('votacao.resultado', {
        parent: 'site',
        url: '/votacao/:id/resultado',
        views:{
            'content@':{
                templateUrl: 'js/votacao/resultado.form.html',
                controller: function(votacaoService, $scope, $stateParams, message, $ionicHistory){
                  $scope.clear = function() {
                    votacaoService.resultado($stateParams.id, function(resultado) {

                      resultado.questoes.forEach(function(questao) {
                        questao.data = questao.validos.map(function (opcao) {
                          return opcao.resultado;
                        });

                        questao.labels = questao.validos.map(function (opcao) {
                          return opcao.opcao;
                        });
                      });

                      $scope.resultado = resultado;
                    });
                  }
                }
            }
        }
    });
}]);
