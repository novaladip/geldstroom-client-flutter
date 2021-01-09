import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/model/transaction_total_model.dart';

void main() {
  test('TransactionTotal', () {
    final json = {
      'income': 100000,
      'expense': 50000,
    };
    final transactionTotal = TransactionTotal.fromJson(json);
    expect(transactionTotal.income, json['income']);
    expect(transactionTotal.expense, json['expense']);
    expect(transactionTotal.toJson, json);
    expect(transactionTotal, TransactionTotal.fromJson(json));
  });
}
