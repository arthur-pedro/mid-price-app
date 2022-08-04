import 'package:intl/intl.dart';
import 'package:midprice/models/deposit/enum_operation.dart';

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

  static bool intToBool(int value) {
    if (value != 0 && value != 1) {
      throw Exception('Erro ao realizar o parse do valor: ${value.toString()}');
    }
    return value == 1 ? true : false;
  }

  static int boolToInt(bool value) {
    return value ? 1 : 0;
  }

  static Operation stringToOperation(String operation) {
    switch (operation) {
      case 'buy':
        return Operation.buy;
      case 'sell':
        return Operation.sell;
      default:
        throw Exception('Operaçao não identificada $operation');
    }
  }
}
