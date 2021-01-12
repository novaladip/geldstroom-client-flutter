import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/get_transaction_dto.dart';

void main() {
  group('GetTransactionDto', () {
    test('toMap', () {
      final now = DateTime.now();
      final dto = GetTransactionDto(
        start: now,
        end: now.add(Duration(days: 7)),
        type: 'INCOME',
        categoryId: 'ALL',
        limit: 16,
        offset: 1,
      );
      expect(dto.toMap, {
        'start': dto.start.microsecondsSinceEpoch,
        'end': dto.end.microsecondsSinceEpoch,
        'type': 'INCOME',
        'limit': dto.limit,
        'offset': dto.offset,
      });
    });

    group('factory', () {
      test('weekly', () {
        final dto = GetTransactionDto.monthly();
        expect(dto, isA<GetTransactionDto>());
      });
      test('monthly', () {
        final dto = GetTransactionDto.weekly();
        expect(dto, isA<GetTransactionDto>());
      });
    });
  });
}
