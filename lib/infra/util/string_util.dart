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
    String tel = unformatTelefone(telefone);

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

  static String formatDataLegivel(DateTime data, Bundle bundle, {bool porHora = false, String pattern = "dd MMMM yyyy"}) {
    var hoje = DateTime.now().toLocal();

    if (porHora) {
      int mins = DateUtil.diferencaMinutos(data, hoje);

      if (hoje.isBefore(data)) {

        if (mins < 5) {
          return bundle['global.agora'];
        }

        if (mins < 60) {
          return bundle.get('global.em_minutos', args: {
            'minutos': mins.toString()
          });
        }

        if (mins < 720) {
          return bundle.get('global.em_horas', args: {
            'horas': (mins ~/ 60).toString()
          });
        }

      } else {

        if (mins < 5) {
          return bundle['global.agora'];
        }

        if (mins < 60) {
          return bundle.get('global.ha_minutos', args: {
            'minutos': mins.toString()
          });
        }

        if (mins < 720) {
          return bundle.get('global.ha_horas', args: {
            'horas': (mins ~/ 60).toString()
          });
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

  static String formataCurrency(double valor) {
    return NumberFormat.currency(locale: 'pt-br', symbol: 'R\$').format(valor);
  }

  static String formatData(DateTime data, {String pattern = "dd/MM/yyyy"}) {
    return DateFormat(pattern).format(data);
  }

  static String formatEndereco(Endereco endereco) {
    return "${endereco.descricao} - ${endereco.cidade} - ${endereco.estado} - ${formataCep(endereco.cep)}";
  }

  static String unformatTelefone(String telefone) {
    return telefone.replaceAll(RegExp("[^0-9]"), "");
  }

  static formatIso(DateTime data) {
    if (data == null) {
      return null;
    }

    return formatData(
      data.toUtc(),
      pattern: "yyyy-MM-dd'T'HH:mm:ss.SSS",
    ) + "Z";
  }

  static primeiroNome(String nomeCompleto) {
    if (nomeCompleto.contains(" ")) {
      return nomeCompleto.substring(0, nomeCompleto.indexOf(" "));
    }

    return nomeCompleto;
  }
}
