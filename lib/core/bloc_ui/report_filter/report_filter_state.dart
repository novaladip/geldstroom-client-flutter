part of 'report_filter_cubit.dart';

@freezed
abstract class ReportFilterState with _$ReportFilterState {
  const factory ReportFilterState({
    @required DateTime start,
    @required DateTime end,
  }) = _ReportFilterState;

  factory ReportFilterState.initial() => ReportFilterState(
        start: Jiffy().startOf(Units.MONTH),
        end: Jiffy().endOf(Units.MONTH),
      );
}
