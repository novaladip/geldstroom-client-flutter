part of 'transaction_delete_cubit.dart';

@freezed
abstract class TransactionDeleteState with _$TransactionDeleteState {
  const factory TransactionDeleteState({
    @required List<String> onDeleteProgressIds,
    @required List<String> onDeleteFailureIds,
    @required List<String> onDeleteSuccessIds,
  }) = _TransactionDeleteState;

  factory TransactionDeleteState.initial() => TransactionDeleteState(
        onDeleteProgressIds: [],
        onDeleteFailureIds: [],
        onDeleteSuccessIds: [],
      );
}

extension TransactionDeleteStateX on TransactionDeleteState {
  TransactionDeleteState addToProgress(String transactionId) {
    return copyWith(
      onDeleteProgressIds: [transactionId, ...onDeleteProgressIds],
    );
  }

  TransactionDeleteState addToSuccess(String transactionId) {
    return copyWith(
      onDeleteProgressIds:
          onDeleteProgressIds.where((id) => id != transactionId).toList(),
      onDeleteSuccessIds: [transactionId, ...onDeleteSuccessIds],
    );
  }

  TransactionDeleteState addToFailure(String transactionId) {
    return copyWith(
      onDeleteProgressIds:
          onDeleteProgressIds.where((id) => id != transactionId).toList(),
      onDeleteFailureIds: [transactionId, ...onDeleteFailureIds],
    );
  }

  TransactionDeleteState removeFromSuccessIds(String transactionId) {
    return copyWith(
      onDeleteSuccessIds:
          onDeleteSuccessIds.where((id) => id != transactionId).toList(),
    );
  }

  TransactionDeleteState removeFromFailureIds(String transactionId) {
    return copyWith(
      onDeleteFailureIds:
          onDeleteFailureIds.where((id) => id != transactionId).toList(),
    );
  }

  bool shouldListenDeleteSuccess(TransactionDeleteState prevState) {
    return onDeleteSuccessIds.isNotEmpty &&
        prevState.onDeleteSuccessIds != onDeleteSuccessIds;
  }

  bool shoudListenDeleteFailure(TransactionDeleteState prevState) {
    return onDeleteFailureIds.isNotEmpty &&
        prevState.onDeleteProgressIds != onDeleteFailureIds;
  }
}
