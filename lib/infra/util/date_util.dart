part of pocket_church.infra;

class DateUtil {
  static bool equalsDateOnly(DateTime data1, DateTime data2) {
    return data1.year == data2.year &&
        data1.month == data2.month &&
        data1.day == data2.day;
  }

  static int diferencaMinutos(DateTime data1, DateTime data2) {
    return ((data1.millisecondsSinceEpoch - data2.millisecondsSinceEpoch) / 60000).floor().abs();
  }

  static bool equalsAniversario(DateTime data1, DateTime data2) {
    return data1.month == data2.month && data1.day == data2.day;
  }

  static bool equalsMonthOnly(DateTime data1, DateTime data2) {
    return data1.year == data2.year && data1.month == data2.month;
  }

  static int compareDateOnly(DateTime data1, DateTime data2) {
    return (data1.year * 1000 + data1.month * 100 + data1.day) -
        (data2.year * 1000 + data2.month * 100 + data2.day);
  }
}
