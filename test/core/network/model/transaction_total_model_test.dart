import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/model/transaction_total_model.dart';

void main() {
  group('TransactionTotal', () {
    final json = {
      'income': 100000,
      'expense': 50000,
    };
    test('fromJson/toJson', () {
      expect(
        TransactionTotal.fromJson(json),
        TransactionTotal.fromJson(TransactionTotal.fromJson(json).toJson),
      );
    });
  });
}
