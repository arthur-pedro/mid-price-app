import 'package:timeago/timeago.dart';

class TimeagoCustomMessage implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'agora';
  @override
  String aboutAMinute(int minutes) => 'Há $minutes min';
  @override
  String minutes(int minutes) => 'Há $minutes min';
  @override
  String aboutAnHour(int minutes) => 'Há $minutes mins';
  @override
  String hours(int hours) => 'Há $hours h';
  @override
  String aDay(int hours) => 'Há $hours h';
  @override
  String days(int days) => 'Há $days d';
  @override
  String aboutAMonth(int days) => 'Há $days d';
  @override
  String months(int months) => 'Há $months m';
  @override
  String aboutAYear(int year) => 'Há $year a';
  @override
  String years(int years) => 'Há $years a';
  @override
  String wordSeparator() => ' ';
}
