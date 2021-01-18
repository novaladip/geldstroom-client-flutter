import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/service/service.dart';

part 'transaction_delete_cubit.freezed.dart';
part 'transaction_delete_state.dart';

@lazySingleton
class TransactionDeleteCubit extends Cubit<TransactionDeleteState> {
  TransactionDeleteCubit(this._service)
      : super(TransactionDeleteState.initial());

  final ITransactionService _service;

  Future<void> delete(String transactionId) async {
    emit(state.addToProgress(transactionId));
    final result = await _service.deleteOneById(transactionId);
    result.fold(
      (l) {
        emit(state.addToFailure(transactionId));
        emit(state.removeFromFailureIds(transactionId));
      },
      (r) {
        emit(state.addToSuccess(transactionId));
        emit(state.removeFromSuccessIds(transactionId));
      },
    );
  }

  void clear() {
    emit(TransactionDeleteState.initial());
  }
}
