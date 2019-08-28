import 'package:flutter/widgets.dart';

class PostTransactionBody {
  final String type;
  final String category;
  final String description;
  final int amount;

  PostTransactionBody({
    @required this.type,
    @required this.category,
    this.description,
    @required this.amount,
  });

  Map<String, dynamic> get toMap {
    return {
      'type': type,
      'category': category,
      'description': description,
      'amount': amount
    };
  }
}
