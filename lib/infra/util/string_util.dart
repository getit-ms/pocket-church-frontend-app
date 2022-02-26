part of pocket_church.infra;

class StringUtil {
  static String nomeResumido(String nomeCompleto) {
    if (nomeCompleto.contains(" ")) {
      return nomeCompleto.substring(0, nomeCompleto.indexOf(" ")) +
          " " +
          nomeCompleto.substring(nomeCompleto.lastIndexOf(" ") + 1);
    }

    return nomeCompleto;
  }

  static String formatTime(num timeInSeconds) {
    int min = 0;
    if (timeInSeconds > 60) {
      min = (timeInSeconds / 60).toInt();
    }

    int sec = timeInSeconds.toInt() % 60;

    return "${min < 10 ? '0' : ''}$min:${sec < 10 ? '0' : ''}$sec";
  }

  static String formatTelefone(String telefone) {
    String formatado = "";
    String tel = unformat(telefone);

    if (tel.length > 11) {
      formatado =
          "(${tel.substring(0, 2)}) ${tel.substring(2, 7)}-${tel.substring(7, 11)}";
    } else if (tel.length > 10) {
      formatado =
          "(${tel.substring(0, 2)}) ${tel.substring(2, 7)}-${tel.substring(7)}";
    } else if (tel.length > 6) {
      formatado =
          "(${tel.substring(0, 2)}) ${tel.substring(2, 6)}-${tel.substring(6)}";
    } else if (tel.length > 2) {
      formatado = "(${tel.substring(0, 2)}) ${tel.substring(2)}";
    } else if (tel.length > 0) {
      formatado = "($tel";
    }

    return formatado;
  }

  static String formatCpfCnpj(String cpfCnpj) {
    String formatado = "";
    String cc = unformat(cpfCnpj);

    if (cc.length > 14) {
      formatado =
          "${cc.substring(0, 2)}.${cc.substring(2, 5)}.${cc.substring(5, 8)}/${cc.substring(8, 12)}-${cc.substring(12, 14)}";
    } else if (cc.length > 12) {
      formatado =
          "${cc.substring(0, 2)}.${cc.substring(2, 5)}.${cc.substring(5, 8)}/${cc.substring(8, 12)}-${cc.substring(12)}";
    } else if (cc.length > 11) {
      formatado =
          "${cc.substring(0, 2)}.${cc.substring(2, 5)}.${cc.substring(5, 8)}/${cc.substring(8)}";
    } else if (cc.length > 9) {
      formatado =
          "${cc.substring(0, 3)}.${cc.substring(3, 6)}.${cc.substring(6, 9)}-${cc.substring(9)}";
    } else if (cc.length > 6) {
      formatado =
          "${cc.substring(0, 3)}.${cc.substring(3, 6)}.${cc.substring(6)}";
    } else if (cc.length > 3) {
      formatado = "${cc.substring(0, 3)}.${cc.substring(3)}";
    } else if (cc.length > 0) {
      formatado = "$cc";
    }

    return formatado;
  }

  static String formataCep(String scep) {
    String formatado = "";

    if (scep != null) {
      String cep = scep.replaceAll(RegExp("[^0-9]"), "");

      if (cep.length > 5) {
        formatado =
            "${cep.substring(0, 2)}-${cep.substring(2, 5)}.${cep.substring(5, 8)}";
      } else if (cep.length > 2) {
        formatado = "${cep.substring(0, 2)}-${cep.substring(2)}";
      } else if (cep.length > 0) {
        formatado = "$cep";
      }
    }

    return formatado;
  }

  static String formatDataString(String data) {
    String formatado = "";

    if (data != null) {
      String unformatted = data.replaceAll(RegExp("[^0-9]"), "");

      if (unformatted.length > 8) {
        formatado =
            "${unformatted.substring(0, 2)}/${unformatted.substring(2, 4)}/${unformatted.substring(4, 8)}";
      } else if (unformatted.length > 4) {
        formatado =
            "${unformatted.substring(0, 2)}/${unformatted.substring(2, 4)}/${unformatted.substring(4)}";
      } else if (unformatted.length > 2) {
        formatado =
            "${unformatted.substring(0, 2)}/${unformatted.substring(2)}";
      } else if (unformatted.length > 0) {
        formatado = unformatted;
      }
    }

    return formatado;
  }

  static String formatDataLegivel(DateTime data, Bundle bundle,
      {bool porHora = false, String pattern = "dd MMMM yyyy"}) {
    var hoje = DateTime.now().toLocal();

    if (porHora) {
      int mins = DateUtil.diferencaMinutos(data, hoje);

      if (hoje.isBefore(data)) {
        if (mins < 5) {
          return bundle['global.agora'];
        }

        if (mins < 60) {
          return bundle
              .get('global.em_minutos', args: {'minutos': mins.toString()});
        }

        if (mins < 720) {
          return bundle
              .get('global.em_horas', args: {'horas': (mins ~/ 60).toString()});
        }
      } else {
        if (mins < 5) {
          return bundle['global.agora'];
        }

        if (mins < 60) {
          return bundle
              .get('global.ha_minutos', args: {'minutos': mins.toString()});
        }

        if (mins < 720) {
          return bundle
              .get('global.ha_horas', args: {'horas': (mins ~/ 60).toString()});
        }
      }
    }

    if (DateUtil.equalsDateOnly(data, hoje)) {
      return bundle['global.hoje'];
    }

    var amanha = hoje.add(Duration(days: 1));
    if (DateUtil.equalsDateOnly(data, amanha)) {
      return bundle['global.amanha'];
    }

    var ontem = hoje.subtract(Duration(days: 1));
    if (DateUtil.equalsDateOnly(data, ontem)) {
      return bundle['global.ontem'];
    }

    return formatData(data, pattern: pattern);
  }

  static formatCount(int numero) {
    String format = "";

    while (numero >= 1000) {
      numero = numero ~/ 1000;
      format += "K";
    }

    return numero.toString() + format;
  }

  static String formatDataLegivelTimeline(DateTime data, Bundle bundle) {
    var hoje = DateTime.now().toLocal();

    if (DateUtil.equalsDateOnly(data, hoje)) {
      int diferencaMin = DateUtil.diferencaMinutos(data, hoje);
      if (diferencaMin < 60) {
        return bundle.get(
          'global.a_minutos',
          args: {'minutos': diferencaMin.toString()},
        );
      }

      int diferencaHoras = DateUtil.diferencaHoras(data, hoje);
      if (diferencaHoras < 12) {
        return bundle.get(
          'global.a_horas',
          args: {'horas': diferencaHoras.toString()},
        );
      }

      return bundle.get(
        'global.hoje_minutos',
        args: {'minutos': formatData(data, pattern: "HH:mm")},
      );
    }

    var ontem = hoje.subtract(Duration(days: 1));
    if (DateUtil.equalsDateOnly(data, ontem)) {
      return bundle.get(
        'global.ontem_minutos',
        args: {'minutos': formatData(data, pattern: "HH:mm")},
      );
    }

    int diferencaDias = DateUtil.diferencaDias(data, hoje);
    if (diferencaDias < 7) {
      return formatData(data, pattern: "EEEE");
    }

    if (data.year == hoje.year) {
      return formatData(data, pattern: "dd MMM HH:mm");
    }

    return formatData(data, pattern: "dd MMM yyyy HH:mm");
  }

  static String formataCurrency(double valor) {
    return NumberFormat.currency(locale: 'pt-br', symbol: 'R\$').format(valor);
  }

  static String formatData(DateTime data, {String pattern = "dd/MM/yyyy"}) {
    return DateFormat(pattern).format(data);
  }

  static DateTime parseData(String data, {String pattern = "dd/MM/yyyy"}) {
    return DateFormat(pattern).parse(data);
  }

  static String formatEndereco(Endereco endereco) {
    return "${endereco.descricao} - ${endereco.cidade} - ${endereco.estado} - ${formataCep(endereco.cep)}";
  }

  static String unformat(String telefone) {
    return telefone.replaceAll(RegExp("[^0-9]"), "");
  }

  static formatIso(DateTime data) {
    if (data == null) {
      return null;
    }

    return formatData(
          data.toUtc(),
          pattern: "yyyy-MM-dd'T'HH:mm:ss.SSS",
        ) +
        "Z";
  }

  static primeiroNome(String nomeCompleto) {
    if (nomeCompleto.contains(" ")) {
      return nomeCompleto.substring(0, nomeCompleto.indexOf(" "));
    }

    return nomeCompleto;
  }
}
