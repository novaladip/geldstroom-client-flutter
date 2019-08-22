import 'package:equatable/equatable.dart';

class Balance extends Equatable {
  final int income;
  final int expense;

  Balance({
    this.income,
    this.expense,
  });
}
