part of pocket_church.infra;

class DateUtil {
  static equalsDateOnly(DateTime data1, DateTime data2) {
    return data1.year == data2.year &&
        data1.month == data2.month &&
        data1.day == data2.day;
  }

  static equalsAniversario(DateTime data1, DateTime data2) {
    return data1.month == data2.month && data1.day == data2.day;
  }

  static bool equalsMonthOnly(DateTime data1, DateTime data2) {
    return data1.year == data2.year &&
        data1.month == data2.month;
  }
}
