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

    test('copyWith', () {
      final now = DateTime.now();
      var dto = GetTransactionDto.weekly();
      final categoryId = '123';
      final start = now;
      final end = now;
      final limit = 20;
      final offset = 60;
      final type = 'EXPENSE';

      dto = dto.copyWith(
        categoryId: categoryId,
        start: start,
        end: end,
        limit: limit,
        offset: offset,
        type: type,
      );
      expect(dto.categoryId, categoryId);
      expect(dto.start, start);
      expect(dto.end, dto.end);
      expect(dto.limit, limit);
      expect(dto.offset, offset);
      expect(dto.type, type);
    });
  });
}
