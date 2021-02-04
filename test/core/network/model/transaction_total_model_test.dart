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

  group('TransactionReport', () {
    final now = DateTime.now();

    final json = {
      'income': [
        {'total': 12000, 'date': now.toIso8601String()},
      ],
      'expense': [
        {'total': 120000, 'date': now.toIso8601String()},
      ],
    };

    test('support value comparations', () {
      final subject = BalanceReport(
        income: [BalanceReportData(date: now, total: 123123)],
        expense: [BalanceReportData(date: now, total: 1231231)],
      );

      final subject2 = BalanceReport(
        income: [BalanceReportData(date: now, total: 123123)],
        expense: [BalanceReportData(date: now, total: 1231231)],
      );

      expect(subject, subject2);
    });

    test('fromJson', () {
      final subject = BalanceReport.fromJson(json);
      expect(subject.income.length, 1);
      expect(subject.expense.length, 1);
    });
  });
  group('TransactionReportData', () {
    final now = DateTime.now();
    test('support value comparations', () {
      final subject = BalanceReportData(
        date: now,
        total: 123000,
      );
      final subject2 = BalanceReportData(
        date: now,
        total: 123000,
      );
      expect(subject, subject2);
    });

    test('fromJson', () {
      final now = DateTime.now();
      final subject = BalanceReportData(
        date: now,
        total: 123000,
      );
      expect(
        subject,
        BalanceReportData.fromJson({
          'total': 123000,
          'date': now.toIso8601String(),
        }),
      );
    });
  });
}
