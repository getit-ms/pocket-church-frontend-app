calvinApp.service('agendaService', ['Restangular', '$filter', function(Restangular, $filter){
        this.api = function(){
            return Restangular.one('agenda');
        };
        
        this.busca = function(filtro, callback){
            return this.api().all('agendamentos/meus').get('', filtro).then(callback);
        };
    
        this.buscaCalendarios = function(){
            return this.api().getList().$object;
        };
        
        this.buscaAgenda = function(id, filtro, callback){
            this.api().one(id + '/agenda').get(filtro).then(callback);
        };
        
        this.agenda = function(id, req, callback){
            this.api().one(id + '/agendar').customPOST(req).then(callback);
        };
        
        this.cancela = function(id, agendamento, callback){
            this.api().one(id + '/cancelar/' + agendamento).post().then(callback);
        };
}]);
        