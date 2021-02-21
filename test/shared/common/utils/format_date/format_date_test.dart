import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/common/utils/utils.dart';

void main() {
  group('FormatDate', () {
    test('normal', () {
      // should return string date with format MM/dd/yyyy
      final date = DateTime.parse('2021-02-11T21:07:40Z');
      final formattedDate = FormatDate.normal(date);
      expect(formattedDate, '02/11/2021');
    });

    test('with clock', () {
      // should return string date with format MM/dd/yyyy hh:mm a
      final date = DateTime.parse('2021-02-11T21:07:40Z');
      final formattedDate = FormatDate.withClock(date);
      expect(formattedDate, '02/11/2021 09:07 PM');
    });
  });
}
