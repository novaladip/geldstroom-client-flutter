import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TransactionTotal extends Equatable {
  const TransactionTotal({
    @required this.income,
    @required this.expense,
  });

  final int income;
  final int expense;

  Map<String, dynamic> get toJson {
    return {
      'income': income,
      'expense': expense,
    };
  }

  factory TransactionTotal.fromJson(Map<String, dynamic> json) {
    return TransactionTotal(
      income: json['income'],
      expense: json['expense'],
    );
  }

  @override
  List<Object> get props => [income, expense];
}

class BalanceReport extends Equatable {
  const BalanceReport({
    @required this.income,
    @required this.expense,
  });

  final List<BalanceReportData> income;
  final List<BalanceReportData> expense;

  factory BalanceReport.fromJson(Map<String, dynamic> json) {
    return BalanceReport(
      income: (json['income'] as List)
          .map((data) => BalanceReportData.fromJson(data))
          .toList(),
      expense: (json['expense'] as List)
          .map((data) => BalanceReportData.fromJson(data))
          .toList(),
    );
  }

  bool get isEmpty {
    var total = 0;
    for (var data in income) {
      total += data.total;
    }
    for (var data in expense) {
      total += data.total;
    }
    return total == 0;
  }

  @override
  List<Object> get props => [income, expense];
}

class BalanceReportData extends Equatable {
  const BalanceReportData({
    @required this.total,
    @required this.date,
  });

  final int total;
  final DateTime date;

  factory BalanceReportData.fromJson(Map<String, dynamic> json) {
    return BalanceReportData(
      total: json['total'],
      date: DateTime.parse(json['date']),
    );
  }

  @override
  List<Object> get props => [total, date];
}
