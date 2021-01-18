import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/transaction_edit_dto.dart';

void main() {
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
}
