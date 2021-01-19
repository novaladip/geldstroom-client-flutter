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
      expect(subject, subject);
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
