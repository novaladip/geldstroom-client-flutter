import 'package:meta/meta.dart';

import 'dto.dart';

class TransactionEditDto implements BaseDto {
  const TransactionEditDto({
    @required this.id,
    @required this.amount,
    @required this.description,
    @required this.type,
    @required this.categoryId,
  });

  final String id;
  final int amount;
  final String description;
  final String type;
  final String categoryId;

  @override
  Map<String, dynamic> get toMap => {
        'amount': amount,
        'description': description,
        'type': type,
        'categoryId': categoryId,
      };
}
