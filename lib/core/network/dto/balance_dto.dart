import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../shared/common/utils/utils.dart';
import 'dto.dart';

class BalanceFilterDto extends Equatable implements BaseDto {
  const BalanceFilterDto({
    @required this.categoryId,
    @required this.start,
    @required this.end,
  });

  final String categoryId;
  final DateTime start; // timestamp
  final DateTime end; // timestamp

  factory BalanceFilterDto.weekly() {
    final dateRange = DateRange.weekly();

    return BalanceFilterDto(
      categoryId: 'ALL',
      start: dateRange.start,
      end: dateRange.end,
    );
  }

  factory BalanceFilterDto.monthly() {
    final dateRange = DateRange.monthly();

    return BalanceFilterDto(
      categoryId: 'ALL',
      start: dateRange.start,
      end: dateRange.end,
    );
  }

  @override
  List<Object> get props => [categoryId, start, end];

  @override
  Map<String, dynamic> get toMap => {
        'category': categoryId,
        'start': start.millisecondsSinceEpoch ~/ 1000,
        'end': end.millisecondsSinceEpoch ~/ 1000,
      };
}
