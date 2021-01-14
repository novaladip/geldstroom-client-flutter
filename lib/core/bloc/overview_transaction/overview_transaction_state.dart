part of 'overview_transaction_bloc.dart';

@freezed
abstract class OverviewTransactionState with _$OverviewTransactionState {
  const OverviewTransactionState._();

  const factory OverviewTransactionState({
    @Default(FetchStatus.initial()) FetchStatus status,
    @Default([]) List<Transaction> data,
    @Default(false) bool isReachEnd,
  }) = _OverviewTransactionState;
}

extension OverviewTransactionStateX on OverviewTransactionState {
  bool get isEmpty {
    final isLoadSuccess = status.maybeWhen<bool>(
      loadSuccess: () => true,
      orElse: () => false,
    );
    return isLoadSuccess && data.isEmpty;
  }
}
