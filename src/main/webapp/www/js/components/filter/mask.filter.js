calvinApp
.filter('mask', function(){
    return function(number, format){
        if (!number) return undefined;

        return mask(number, format);
    }
})
.filter('zpad', function(){
  return function(number, size){
    if (!number) return undefined;

    var snumber = number + '';

    while (snumber.length < size) {
      snumber = '0' + snumber;
    }

    return snumber;
  }
}).filter('telefone', function(){
        return function(numero){
            if (!numero) return undefined;

            if (numero.length > 10){
                return mask(numero, '(99) 99999-9999');
            }else{
                return mask(numero, '(99) 9999-9999');
            }
        }
    }
).directive('mask', ['$filter', function($filter) {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function ($scope, $element, attrs, ngModel) {
            ngModel.$parsers.unshift(function (value) {
                return unmask(value, attrs.mask, $element, ngModel);
            });

            ngModel.$formatters.unshift(function (value) {
                return mask(value, attrs.mask);
            });
        }
    }
}]).directive('telefone', ['$filter', function($filter){
    return {
        restrict: 'A',
        require:'ngModel',
        link: function($scope, $element, attrs, ngModel){
            ngModel.$parsers.unshift(function(value){
                return unmask(value, function(value){
                    return value.length > 10 ? '(99) 99999-9999' : '(99) 9999-9999';
                }, $element, ngModel);
            });

            ngModel.$formatters.unshift(function(value){
                return $filter('telefone')(value);
            });
        }
    };
}]);

function unmask(value, smask, $element, ngModel){
    if (value) {
        value = value.replace(/[^0-9]/g, '');
        if (angular.isFunction(smask)){
            smask = smask(value);
        }

        var maxLength = smask.replace(/[^9]/g, '').length;
        if (value.length > maxLength){
            value = value.substring(value.length - maxLength);
        }

        $element.val(mask(value, smask));

        if (value.length < maxLength){
            ngModel.$setValidity('mask', false);
            return;
        }

        ngModel.$setValidity('mask', true);
        return value;
    }
}

function validaCnpj(str){
    str = str.replace(/[^0-9]/g,'');
    cnpj = str;
    var numeros, digitos, soma, i, resultado, pos, tamanho, digitos_iguais;
    digitos_iguais = 1;
    if (cnpj.length < 14 && cnpj.length < 15)
        return false;
    for (i = 0; i < cnpj.length - 1; i++)
        if (cnpj.charAt(i) != cnpj.charAt(i + 1))
        {
            digitos_iguais = 0;
            break;
        }
    if (!digitos_iguais)
    {
        tamanho = cnpj.length - 2
        numeros = cnpj.substring(0,tamanho);
        digitos = cnpj.substring(tamanho);
        soma = 0;
        pos = tamanho - 7;
        for (i = tamanho; i >= 1; i--)
        {
            soma += numeros.charAt(tamanho - i) * pos--;
            if (pos < 2)
                pos = 9;
        }
        resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
        if (resultado != digitos.charAt(0))
            return false;
        tamanho = tamanho + 1;
        numeros = cnpj.substring(0,tamanho);
        soma = 0;
        pos = tamanho - 7;
        for (i = tamanho; i >= 1; i--)
        {
            soma += numeros.charAt(tamanho - i) * pos--;
            if (pos < 2)
                pos = 9;
        }
        resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
        if (resultado != digitos.charAt(1))
            return false;
        return true;
    }
    else
        return false;
}

function mask(snumber, format){
    if (snumber){
        var idx = -1;
        while (snumber.length && (idx = format.indexOf('9', idx + 1)) >= 0){
            format = format.slice(0, idx) + snumber.charAt(0) + format.slice(idx + 1);
            snumber = snumber.slice(1);
        }

        if (idx >= 0){
            format = format.slice(0, idx + 1);
        }

        return format;
    }
}
