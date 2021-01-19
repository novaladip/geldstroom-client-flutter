import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';

void main() {
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
}
