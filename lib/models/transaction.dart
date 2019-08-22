import 'package:equatable/equatable.dart';

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
  },);
}
