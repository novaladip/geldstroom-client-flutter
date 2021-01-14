import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/network.dart';

import '../../../helper_tests/tranasction_json.dart';

void main() {
  group('Transaction', () {
    final transaction =
        Transaction.fromJson(TransactionJson.listTransaction[0]);
    test('should support comparations value', () {
      expect(transaction, transaction);
    });

    test('formattedAmount', () {
      expect(transaction.formattedAmount.contains('IDR'), true);
    });

    test('toJson', () {
      expect(transaction.toJson, isA<Map<String, dynamic>>());
    });
  });

  group('TransactionCategory', () {
    final subject = TransactionCategory(
      credit: 'John',
      iconUrl: 'https://link.img',
      id: 'ewqeq-ead',
      name: 'Food',
    );

    test('should support comparations value', () {
      expect(subject, subject);
    });

    test('fromJson/toJson', () {
      expect(subject, TransactionCategory.fromJson(subject.toJson));
    });
  });
}
