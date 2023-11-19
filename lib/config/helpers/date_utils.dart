import 'package:intl/intl.dart';

class DateUtils {
  static String formatDateTime(DateTime dateTime,
      [String format = 'dd/MM/yyyy HH:mm:ss']) {
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }
}
