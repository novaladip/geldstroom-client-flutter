part of 'delete_cubit.dart';

@freezed
abstract class DeleteState with _$DeleteState {
  const factory DeleteState({
    @required List<String> onDeleteProgressIds,
    @required List<String> onDeleteFailureIds,
    @required List<String> onDeleteSuccessIds,
  }) = _DeleteState;

  factory DeleteState.initial() => DeleteState(
        onDeleteProgressIds: [],
        onDeleteFailureIds: [],
        onDeleteSuccessIds: [],
      );
}

/// adding given id to onDeleteProggressIds
extension DeleteStateX on DeleteState {
  DeleteState addToProgress(String id) {
    return copyWith(
      onDeleteProgressIds: [id, ...onDeleteProgressIds],
    );
  }

  /// removing given id from onDeleteProgressIds
  /// and adding given id to onDeleteSuccessIds
  /// return new object of DeleteStatus
  DeleteState addToSuccess(String id) {
    return copyWith(
      onDeleteProgressIds:
          onDeleteProgressIds.where((value) => value != id).toList(),
      onDeleteSuccessIds: [id, ...onDeleteSuccessIds],
    );
  }

  /// removing given id from onDeleteProgressIds
  /// and adding given id to onDeleteFailureIds
  DeleteState addToFailure(String id) {
    return copyWith(
      onDeleteProgressIds:
          onDeleteProgressIds.where((value) => value != id).toList(),
      onDeleteFailureIds: [id, ...onDeleteFailureIds],
    );
  }

  /// removing given id from onDeleteSuccessIds
  DeleteState removeFromSuccessIds(String transactionId) {
    return copyWith(
      onDeleteSuccessIds:
          onDeleteSuccessIds.where((id) => id != transactionId).toList(),
    );
  }

  /// removing given id from onDeleteFailureIds
  DeleteState removeFromFailureIds(String transactionId) {
    return copyWith(
      onDeleteFailureIds:
          onDeleteFailureIds.where((id) => id != transactionId).toList(),
    );
  }

  /// return bool based on prev and current state
  bool shouldListenDeleteSuccess(DeleteState prevState) {
    return onDeleteSuccessIds.isNotEmpty &&
        prevState.onDeleteSuccessIds != onDeleteSuccessIds;
  }

  /// return bool based on prev and current state
  bool shoudListenDeleteFailure(DeleteState prevState) {
    return onDeleteFailureIds.isNotEmpty &&
        prevState.onDeleteProgressIds != onDeleteFailureIds;
  }
}
