import 'package:jiffy/jiffy.dart';

class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange._({
    this.start,
    this.end,
  });

  factory DateRange.weekly() {
    return DateRange._(
      start: Jiffy().startOf(Units.WEEK),
      end: Jiffy().endOf(Units.WEEK),
    );
  }

  factory DateRange.monthly() {
    return DateRange._(
      start: Jiffy().startOf(Units.MONTH),
      end: Jiffy().endOf(Units.MONTH),
    );
  }
}
