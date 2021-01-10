import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/common/utils/utils.dart';

void main() {
  group('FormatCurrency', () {
    test('toIDR', () {
      final number = 10000;
      expect(FormatCurrency.toIDR(number), 'IDR10.000');
    });
  });
}
