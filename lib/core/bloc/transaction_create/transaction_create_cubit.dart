import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../network/dto/dto.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';

@lazySingleton
class TransactionCreateCubit extends Cubit<FormStatusData<Transaction>> {
  TransactionCreateCubit(this._service) : super(FormStatusData.idle());

  final ITransactionService _service;

  Future<void> submit(TransactionCreateDto dto) async {
    emit(FormStatusData.loading());
    final result = await _service.create(dto);
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
