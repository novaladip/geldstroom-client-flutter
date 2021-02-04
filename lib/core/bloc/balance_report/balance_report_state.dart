part of 'balance_report_cubit.dart';

@freezed
abstract class BalanceReportState with _$BalanceReportState {
  const factory BalanceReportState({
    @required FetchStatus status,
    @required BalanceReport data,
  }) = _BalanceReportState;

  factory BalanceReportState.initial() => BalanceReportState(
        status: FetchStatus.initial(),
        data: BalanceReport(
          income: [],
          expense: [],
        ),
      );
}
