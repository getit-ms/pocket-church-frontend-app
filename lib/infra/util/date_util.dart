part of pocket_church.infra;

extension DateExtension on DateTime {
  DateTime trunc() {
    return DateTime(year, month, day);
  }
}

class DateUtil {
  static int _MILLIS_MINUTO = 1000 * 60;
  static int _MILLIS_HORA = _MILLIS_MINUTO * 60;
  static int _MILLIS_DIA = _MILLIS_HORA * 24;

  static equalsDateOnly(DateTime data1, DateTime data2) {
    return data1.year == data2.year &&
        data1.month == data2.month &&
        data1.day == data2.day;
  }

  static equalsAniversario(DateTime data1, DateTime data2) {
    return data1.month == data2.month && data1.day == data2.day;
  }

  static bool equalsMonthOnly(DateTime data1, DateTime data2) {
    return data1.year == data2.year && data1.month == data2.month;
  }

  static int diferencaMinutos(DateTime data1, DateTime data2) {
    return ((data1.millisecondsSinceEpoch - data2.millisecondsSinceEpoch)
        .abs() /
        _MILLIS_MINUTO)
        .ceil();
  }

  static int diferencaHoras(DateTime data1, DateTime data2) {
    return ((data1.millisecondsSinceEpoch - data2.millisecondsSinceEpoch)
        .abs() /
        _MILLIS_HORA)
        .ceil();
  }

  static int diferencaDias(DateTime data1, DateTime data2) {
    return ((data1.millisecondsSinceEpoch - data2.millisecondsSinceEpoch)
        .abs() /
        _MILLIS_DIA)
        .ceil();
  }
}
