import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart' as intl;

class Transaction extends Equatable {
  final String id;
  final int amount;
  final String description;
  final String type;
  final TransactionCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const Transaction({
    @required this.id,
    @required this.amount,
    @required this.description,
    @required this.type,
    @required this.category,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.userId,
  });

  String get formattedAmount => intl.NumberFormat.currency(
        locale: 'IN',
        decimalDigits: 0,
        symbol: 'IDR',
      ).format(amount);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      type: json['type'],
      userId: json['userId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (json['createdAt'] as int) * 1000,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (json['updatedAt'] as int) * 1000,
      ),
      category: TransactionCategory.fromJson(json['category']),
    );
  }

  Map<String, dynamic> get toJson => {
        'id': id,
        'amount': amount,
        'description': description,
        'type': type,
        'userId': userId,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
        'category': category.toJson,
      };

  @override
  List<Object> get props =>
      [id, amount, description, type, category, createdAt, updatedAt, userId];
}

class TransactionCategory extends Equatable {
  const TransactionCategory({
    @required this.id,
    @required this.name,
    @required this.iconUrl,
    @required this.credit,
  });

  final String id;
  final String name;
  final String iconUrl;
  final String credit;

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'],
      name: json['name'],
      iconUrl: json['iconURL'],
      credit: json['credit'],
    );
  }

  Map<String, dynamic> get toJson => {
        'id': id,
        'name': name,
        'iconURL': iconUrl,
        'credit': credit,
      };

  @override
  List<Object> get props => [id, name, credit, iconUrl];
}
