part of pocket_church.infra;

typedef Validator<T> = Function(T valor, Bundle bundle);

FormFieldValidator<T> validate<T>(
  List<Validator<T>> validators, {
  Bundle bundle = const Bundle({}),
  bool enabled = true,
}) {
  return (T valor) {
    if (enabled) {
      for (Validator<T> val in validators) {
        var msg = val(valor, bundle);
        if (msg != null) {
          return msg;
        }
      }
    }

    return null;
  };
}

Validator<String> notEmpty() {
  return (String valor, Bundle bundle) {
    if (valor == null || valor.isEmpty) {
      return bundle["validacao.notEmpty"];
    }

    return null;
  };
}

Validator<String> email() {
  return (String valor, Bundle bundle) {
    if (valor != null && !RegExp("^.+@.+\$").hasMatch(valor)) {
      return bundle["validacao.email"];
    }

    return null;
  };
}

Validator<String> length({int max, int min}) {
  return (String valor, Bundle bundle) {
    if (valor != null) {
      if (min != null && min > valor.length) {
        return bundle["validacao.length.min"]
            .replaceAll("{min}", min.toString());
      }

      if (max != null && max < valor.length) {
        return bundle["validacao.length.max"]
            .replaceAll("{max}", max.toString());
      }
    }

    return null;
  };
}
