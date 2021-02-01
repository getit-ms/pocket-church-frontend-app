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

Validator<T> notNull<T>() {
  return (T valor, Bundle bundle) {
    if (valor == null) {
      return bundle["validacao.notEmpty"];
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

Validator<T> range<T extends num>({T max, T min, String Function(num val) toString}) {
  return (T valor, Bundle bundle) {
    toString ??= (val) => val.toString();

    if (valor != null) {
      if (min != null && min > valor) {
        return bundle["validacao.range.min"]
            .replaceAll("{min}", toString(min));
      }

      if (max != null && max < valor) {
        return bundle["validacao.range.max"]
            .replaceAll("{max}", toString(max));
      }
    }

    return null;
  };
}

Validator<DateTime> dateRange({DateTime max, DateTime min}) {
  return (DateTime valor, Bundle bundle) {
    if (valor != null) {
      if (min != null && min.millisecondsSinceEpoch > valor.millisecondsSinceEpoch) {
        return bundle["validacao.dateRange.min"]
            .replaceAll("{min}", StringUtil.formatData(min));
      }

      if (max != null && max.millisecondsSinceEpoch < valor.millisecondsSinceEpoch) {
        return bundle["validacao.dateRange.max"]
            .replaceAll("{max}", StringUtil.formatData(max));
      }
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
