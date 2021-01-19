import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'dto.dart';

class TransactionCreateDto extends Equatable implements BaseDto {
  final String description;
  final int amount;
  final String categoryId;
  final String type;

  const TransactionCreateDto({
    @required this.description,
    @required this.amount,
    @required this.categoryId,
    @required this.type,
  });

  @override
  List<Object> get props => [description, amount, categoryId, type];

  @override
  Map<String, dynamic> get toMap => {
        'description': description,
        'amount': amount,
        'category_id': categoryId,
        'type': type,
      };
}
