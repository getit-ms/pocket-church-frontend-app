part of pocket_church.infra;

class TextFormatUtil {

  static TextEditingValue formatTelefone(TextEditingValue antigo, TextEditingValue novo) {
    String tel = novo.text.replaceAll(RegExp("[^0-9]"), "");
    String formatado = StringUtil.formatTelefone(tel);

    int offset = formatado.length;

    if (novo.selection.start != novo.text.length) {
      offset = min(formatado.length, novo.selection.start);
    }

    return TextEditingValue(
        text: formatado,
        selection: TextSelection.fromPosition(TextPosition(
            offset: offset
        ))
    );
  }
}

