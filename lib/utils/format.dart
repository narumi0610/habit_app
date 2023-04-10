import 'package:intl/intl.dart';

class Format {
  static String yyyymmdd(DateTime dt) {
    return DateFormat('yyyy/MM/dd').format(dt);
  }
}
