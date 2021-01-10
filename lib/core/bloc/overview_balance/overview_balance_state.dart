part of 'overview_balance_cubit.dart';

@freezed
abstract class OverviewBalanceState with _$OverviewBalanceState {
  const factory OverviewBalanceState({
    @required Status status,
    @required TransactionTotal data,
  }) = _OverviewBalanceState;

  factory OverviewBalanceState.initial() => OverviewBalanceState(
        status: Status.initial(),
        data: TransactionTotal(expense: 0, income: 0),
      );
}

@freezed
abstract class Status with _$Status {
  const factory Status.initial() = _StatusInitial;
  const factory Status.loading() = _StatusLoading;
  const factory Status.loaded() = _StatusLoaded;
  const factory Status.error({
    @required ServerError error,
  }) = _StatusError;
}
