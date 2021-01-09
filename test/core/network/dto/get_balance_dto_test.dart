import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/get_balance_dto.dart';

void main() {
  group('GetBalanceDto', () {
    final weekly = GetBalanceDto.weekly();
    final monthly = GetBalanceDto.monthly();

    test('monthly/weekly work properly', () {
      expect(weekly.start, isA<DateTime>());
      expect(weekly.end, isA<DateTime>());

      expect(monthly.start, isA<DateTime>());
      expect(monthly.end, isA<DateTime>());
    });

    test('props work properly', () {
      expect(weekly != monthly, true);
    });

    test('toMap work properly', () {
      final map = weekly.toMap;
      expect(map['categoryId'], 'ALL');
      expect(map['start'], weekly.start.millisecondsSinceEpoch);
      expect(map['end'], weekly.end.millisecondsSinceEpoch);
    });
  });
}
