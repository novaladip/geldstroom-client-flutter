import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';

void main() {
  group('BalanceDto', () {
    group('BalanceFilterDto', () {
      final weekly = BalanceFilterDto.weekly();
      final monthly = BalanceFilterDto.monthly();

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
        expect(map['category'], 'ALL');
        expect(map['start'], weekly.start.millisecondsSinceEpoch ~/ 1000);
        expect(map['end'], weekly.end.millisecondsSinceEpoch ~/ 1000);
      });
    });
  });
}
