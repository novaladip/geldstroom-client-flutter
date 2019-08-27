import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Balance extends Equatable {
  final int income;
  final int expense;

  Balance({
    @required this.income,
    @required this.expense,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      income: int.parse(json['INCOME']) ?? 0,
      expense: int.parse(json['EXPENSE']) ?? 0,
    );
  }
}
