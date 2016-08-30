calvinApp.service('linkService', ['$window', function($window){
        this.mailto = function(email){
            if (!email) return;
            $window.open('mailto:' + email, '_system');
        };

        this.tel = function(tel){
            if (!tel) return;
            $window.open('tel: ' + tel.replace(/[^0-9]/g, ''), '_system');
        };

        this.geo = function(endereco){
            if (!endereco || !endereco.descricao) return;
            if (ionic.Platform.isIOS()){
                $window.open('maps://maps.apple.com/?daddr=' + endereco.descricao + ' ' + endereco.cidade + ' ' + endereco.estado, '_system');
            }else{
                $window.open('geo:0,0?q=' + endereco.descricao + ' ' + endereco.cidade + ' ' + endereco.estado, '_system');
            }
        };

        this.site = function(site){
            if (!site) return;
            if (site.indexOf('http://') < 0 &&
                    site.indexOf('https://') < 0){
                site = 'http://' + site;
            }
            $window.open(site, '_system');
        };
}]);
        