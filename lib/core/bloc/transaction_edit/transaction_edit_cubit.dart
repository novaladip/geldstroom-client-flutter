import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../network/dto/dto.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';

@lazySingleton
class TransactionEditCubit extends Cubit<FormStatusData<Transaction>> {
  TransactionEditCubit(this._service) : super(FormStatusData.idle());

  final ITransactionService _service;

  Future<void> submit(TransactionEditDto dto) async {
    emit(FormStatusData.loading());
    final result = await _service.edit(dto);
    result.fold(
      (l) {
        emit(FormStatusData.error(error: l));
      },
      (r) {
        emit(FormStatusData.success(data: r));
      },
    );
  }

  void clear() {
    emit(FormStatusData.idle());
  }
}
