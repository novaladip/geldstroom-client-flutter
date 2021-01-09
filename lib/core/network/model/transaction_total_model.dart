import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TransactionTotal extends Equatable {
  const TransactionTotal({
    @required this.income,
    @required this.expense,
  });

  final int income;
  final int expense;

  factory TransactionTotal.fromJson(Map<String, dynamic> json) {
    return TransactionTotal(
      income: json['income'],
      expense: json['expense'],
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'income': income,
      'expense': expense,
    };
  }

  @override
  List<Object> get props => [income, expense];
}
