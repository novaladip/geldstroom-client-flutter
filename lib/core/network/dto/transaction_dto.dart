import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../shared/common/utils/utils.dart';
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

class TransactionEditDto extends Equatable implements BaseDto {
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

  @override
  List<Object> get props => [id, amount, description, type, categoryId];
}

class TransactionFilterDto implements BaseDto {
  static const _defaultType = 'ALL';
  static const _defaultCategoryId = 'ALL';
  static const _defaultLimit = 15;
  static const _defaultOffset = 0;

  const TransactionFilterDto({
    @required this.start,
    @required this.end,
    this.categoryId = _defaultCategoryId,
    this.type = _defaultType,
    this.limit = _defaultLimit,
    this.offset = _defaultOffset,
  });

  final String categoryId;
  final String type;
  final int limit;
  final int offset;
  final DateTime start;
  final DateTime end;

  @override
  Map<String, dynamic> get toMap {
    final map = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'start': start.millisecondsSinceEpoch ~/ 1000,
      'end': end.millisecondsSinceEpoch ~/ 1000,
    };

    if (type != _defaultType) map['type'] = type;
    if (categoryId != _defaultCategoryId) map['category'] = categoryId;

    return map;
  }

  factory TransactionFilterDto.weekly({
    String categoryId,
    String type,
    int limit = _defaultLimit,
    int offset = _defaultOffset,
  }) {
    final dateRange = DateRange.weekly();

    return TransactionFilterDto(
      categoryId: categoryId,
      type: type,
      start: dateRange.start,
      end: dateRange.end,
    );
  }

  factory TransactionFilterDto.monthly({
    String categoryId,
    String type,
    int limit = _defaultLimit,
    int offset = _defaultOffset,
  }) {
    final dateRange = DateRange.monthly();

    return TransactionFilterDto(
      categoryId: categoryId,
      type: type,
      start: dateRange.start,
      end: dateRange.end,
    );
  }

  TransactionFilterDto copyWith({
    String categoryId,
    String type,
    int limit,
    int offset,
    DateTime start,
    DateTime end,
  }) {
    return TransactionFilterDto(
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      limit: limit ?? this.limit,
      offset: offset ?? this.limit,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}
