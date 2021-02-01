part of pocket_church.infra;

class TextFormatUtil {
  static TextEditingValue formatTelefone(
      TextEditingValue antigo, TextEditingValue novo) {
    String tel = novo.text.replaceAll(RegExp("[^0-9]"), "");
    String formatado = StringUtil.formatTelefone(tel);

    int offset = formatado.length;

    if (novo.selection.start != novo.text.length) {
      offset = min(formatado.length, novo.selection.start);
    }

    return TextEditingValue(
        text: formatado,
        selection: TextSelection.fromPosition(TextPosition(offset: offset)));
  }

  static TextEditingValue formatCEP(
      TextEditingValue antigo, TextEditingValue novo) {
    String tel = novo.text.replaceAll(RegExp("[^0-9]"), "");
    String formatado = StringUtil.formataCep(tel);

    int offset = formatado.length;

    if (novo.selection.start != novo.text.length) {
      offset = min(formatado.length, novo.selection.start);
    }

    return TextEditingValue(
        text: formatado,
        selection: TextSelection.fromPosition(TextPosition(offset: offset)));
  }

  static TextEditingValue formatCpfCnpj(
      TextEditingValue antigo, TextEditingValue novo) {
    String formatado = StringUtil.formatCpfCnpj(novo.text);

    int offset = formatado.length;

    if (novo.selection.start != novo.text.length) {
      offset = min(formatado.length, novo.selection.start);
    }

    return TextEditingValue(
        text: formatado,
        selection: TextSelection.fromPosition(TextPosition(offset: offset)));
  }

  static TextEditingValue formatInt(
      TextEditingValue antigo, TextEditingValue novo) {
    String formatado = StringUtil.unformat(novo.text);

    int offset = formatado.length;

    if (novo.selection.start != novo.text.length) {
      offset = min(formatado.length, novo.selection.start);
    }

    return TextEditingValue(
      text: formatado,
      selection: TextSelection.fromPosition(TextPosition(offset: offset)),
    );
  }

  static TextEditingValue formatCurrency(
      TextEditingValue antigo, TextEditingValue novo) {
    if (novo.selection.baseOffset == 0) {
      print(true);
      return novo;
    }

    double value = double.parse(novo.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return novo.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }

  static TextEditingValue formataData(
      TextEditingValue antigo, TextEditingValue novo) {
    String formatado = StringUtil.formatDataString(novo.text);

    int offset = formatado.length;

    if (novo.selection.start != novo.text.length) {
      offset = min(formatado.length, novo.selection.start);
    }

    return TextEditingValue(
      text: formatado,
      selection: TextSelection.fromPosition(TextPosition(offset: offset)),
    );
  }
}
