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

class TransactionReport extends Equatable {
  const TransactionReport({
    @required this.income,
    @required this.expense,
  });

  final List<TransactionReportData> income;
  final List<TransactionReportData> expense;

  factory TransactionReport.fromJson(Map<String, dynamic> json) {
    return TransactionReport(
      income: (json['income'] as List)
          .map((data) => TransactionReportData.fromJson(data))
          .toList(),
      expense: (json['expense'] as List)
          .map((data) => TransactionReportData.fromJson(data))
          .toList(),
    );
  }

  @override
  List<Object> get props => [income, expense];
}

class TransactionReportData extends Equatable {
  const TransactionReportData({
    @required this.total,
    @required this.date,
  });

  final int total;
  final DateTime date;

  factory TransactionReportData.fromJson(Map<String, dynamic> json) {
    return TransactionReportData(
      total: json['total'],
      date: DateTime.parse(json['date']),
    );
  }

  @override
  List<Object> get props => [total, date];
}
