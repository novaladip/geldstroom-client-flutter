import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/transaction_dto.dart';

void main() {
  group('TransactionDto', () {
    group('TransactionCreateDto', () {
      final subject = TransactionCreateDto(
        description: 'beli lotek',
        amount: 32000,
        categoryId: '123-123-123',
        type: 'EXPENSE',
      );

      test('support comparations value', () {
        final dto = TransactionCreateDto(
          description: 'beli lotek2',
          amount: 320000,
          categoryId: '123-123-123',
          type: 'EXPENSE',
        );
        expect(subject == dto, false);
      });

      test('toMap', () {
        expect(subject.toMap, {
          'description': 'beli lotek',
          'amount': 32000,
          'category_id': '123-123-123',
          'type': 'EXPENSE',
        });
      });
    });

    group('TransactionEditDto', () {
      final dto = TransactionEditDto(
        id: '123123',
        amount: 10000,
        categoryId: '1234-5678',
        description: 'some food',
        type: 'EXPENSE',
      );

      test('toMap', () {
        expect(dto.toMap, {
          'amount': dto.amount,
          'categoryId': dto.categoryId,
          'type': dto.type,
          'description': dto.description,
        });
      });

      test('support comparations value', () {
        expect(dto, dto);
      });
    });

    group('TransactionFilterDto', () {
      test('toMap', () {
        final now = DateTime.now();
        final dto = TransactionFilterDto(
          start: now,
          end: now.add(Duration(days: 7)),
          type: 'INCOME',
          categoryId: 'ALL',
          limit: 16,
          offset: 1,
        );
        expect(dto.toMap, isA<Map<String, dynamic>>());
      });

      group('factory', () {
        test('weekly', () {
          final dto = TransactionFilterDto.monthly();
          expect(dto, isA<TransactionFilterDto>());
        });
        test('monthly', () {
          final dto = TransactionFilterDto.weekly();
          expect(dto, isA<TransactionFilterDto>());
        });
      });

      test('copyWith', () {
        final now = DateTime.now();
        var dto = TransactionFilterDto.weekly();
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
  });
}
