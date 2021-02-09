import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../network/model/model.dart';

part 'delete_cubit.freezed.dart';
part 'delete_state.dart';

typedef DeleteFunction = Future<Either<ServerError, None>> Function(String dto);

class DeleteCubit extends Cubit<DeleteState> {
  DeleteCubit(this.deleteFunction) : super(DeleteState.initial());

  final DeleteFunction deleteFunction;

  Future<void> delete(String id) async {
    emit(state.addToProgress(id));
    final result = await deleteFunction(id);
    result.fold(
      (l) {
        emit(state.addToFailure(id));
        emit(state.removeFromFailureIds(id));
      },
      (r) {
        emit(state.addToSuccess(id));
        emit(state.removeFromSuccessIds(id));
      },
    );
  }

  void clear() {
    emit(DeleteState.initial());
  }
}
