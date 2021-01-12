import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/common/utils/date_range/date_range.dart';

void main() {
  group('DateRange', () {
    test('weekly', () {
      final dateRange = DateRange.monthly();
      expect(dateRange.start, isA<DateTime>());
      expect(dateRange.end, isA<DateTime>());
    });

    test('monthly', () {
      final dateRange = DateRange.weekly();
      expect(dateRange.start, isA<DateTime>());
      expect(dateRange.end, isA<DateTime>());
    });
  });
}
