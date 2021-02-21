import 'package:jiffy/jiffy.dart';

class FormatDate {
  /// format an input date into string MM/dd/yyyy
  static String normal(DateTime date) {
    return Jiffy(date).format('MM/dd/yyyy');
  }

  /// format an input date into string MM/dd/yyyy hh:mm a
  static String withClock(DateTime date) {
    return Jiffy(date).format('MM/dd/yyyy hh:mm a');
  }
}
