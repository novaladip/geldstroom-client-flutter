part of 'overview_transaction_bloc.dart';

@freezed
abstract class OverviewTransactionEvent with _$OverviewTransactionEvent {
  const factory OverviewTransactionEvent.fetch() = _Fetch;
  const factory OverviewTransactionEvent.add(Transaction transaction) = _Add;
  const factory OverviewTransactionEvent.delete(String id) = _Delete;
  const factory OverviewTransactionEvent.update(Transaction transaction) =
      _Update;
  const factory OverviewTransactionEvent.fetchMore() = _FetchMore;
  const factory OverviewTransactionEvent.clear() = _Clear;
}
