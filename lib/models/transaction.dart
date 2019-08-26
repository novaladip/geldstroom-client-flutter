import 'package:equatable/equatable.dart';

enum TransactionCategory {
  ALL,
  FOOD,
  HOBBY,
  EDUCATION,
}

enum TransactionType {
  ALL,
  INCOME,
  EXPENSE,
}

enum IsMonthly {
  DAILY,
  MONTHLY,
}

class Transaction extends Equatable {
  final String id;
  final int amount;
  final String category;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String description;
  final String userId;

  Transaction({
    this.id,
    this.amount,
    this.category,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.userId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      category: json['category'],
      type: json['type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      description: json['description'],
      userId: json['userId'],
    );
  }
}
