import 'package:intl/intl.dart';

abstract class Parser {
  static String doubleToString(double value) {
    return value.toString();
  }

  static double stringToDouble(String value) {
    return double.parse(value);
  }

  static String dateToString(DateTime date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.format(date);
  }

  static int dateToMilliseconds(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  static DateTime millisecondsToDate(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  static String millisecondsToString(int milliseconds) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.format(millisecondsToDate(milliseconds));
  }
}
