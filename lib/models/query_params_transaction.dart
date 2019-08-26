import 'package:flutter/foundation.dart';

import 'package:geldstroom/models/transaction.dart';
import 'package:geldstroom/utils/enum_to_string.dart';

class QueryParamsTransaction {
  final String date;
  final TransactionType type;
  final TransactionCategory category;
  final IsMonthly isMonthly;
  final int page;
  final int limit;

  QueryParamsTransaction({
    @required this.date,
    @required this.isMonthly,
    @required this.page,
    @required this.limit,
    this.type,
    this.category,
  });

  Map<String, dynamic> get params {
    final Map<String, dynamic> param = {
      'date': date,
      'page': page,
      'limit': limit,
      'isMonthly': isMonthly.index,
    };

    if (type != null && type != TransactionType.ALL) {
      param['type'] = enumToString<TransactionType>(type);
    }

    if (category != null && category != TransactionCategory.ALL) {
      param['category'] = enumToString<TransactionCategory>(category);
    }

    return param;
  }
}
