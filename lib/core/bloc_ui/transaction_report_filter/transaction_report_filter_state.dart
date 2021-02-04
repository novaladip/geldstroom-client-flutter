part of 'transaction_report_filter_cubit.dart';

@freezed
abstract class TransactionReportFilterState
    with _$TransactionReportFilterState {
  const factory TransactionReportFilterState({
    @required DateTime start,
    @required DateTime end,
  }) = _TransactionReportFilterState;

  factory TransactionReportFilterState.initial() =>
      TransactionReportFilterState(
        start: Jiffy().startOf(Units.MONTH),
        end: Jiffy().endOf(Units.MONTH),
      );
}
