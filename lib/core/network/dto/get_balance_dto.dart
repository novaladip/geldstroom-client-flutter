import 'package:equatable/equatable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:meta/meta.dart';

import 'dto.dart';

class GetBalanceDto extends Equatable implements BaseDto {
  const GetBalanceDto({
    @required this.categoryId,
    @required this.start,
    @required this.end,
  });

  final String categoryId;
  final DateTime start; // timestamp
  final DateTime end; // timestamp

  factory GetBalanceDto.weekly() {
    final now = Jiffy();
    final start = now.startOf(Units.WEEK);
    final end = now.endOf(Units.WEEK);

    return GetBalanceDto(
      categoryId: 'ALL',
      start: start,
      end: end,
    );
  }

  factory GetBalanceDto.monthly() {
    final now = Jiffy();
    final start = now.startOf(Units.MONTH);
    final end = now.endOf(Units.MONTH);

    return GetBalanceDto(
      categoryId: 'ALL',
      start: start,
      end: end,
    );
  }

  @override
  List<Object> get props => [categoryId, start, end];

  @override
  Map<String, dynamic> get toMap => {
        'categoryId': categoryId,
        'start': start.millisecondsSinceEpoch ~/ 1000,
        'end': end.millisecondsSinceEpoch ~/ 1000,
      };
}
