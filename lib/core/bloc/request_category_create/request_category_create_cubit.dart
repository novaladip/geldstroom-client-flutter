import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../network/dto/dto.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';

@lazySingleton
class RequestCategoryCreateCubit
    extends Cubit<FormStatusData<RequestCategory>> {
  RequestCategoryCreateCubit(this._service)
      : super(FormStatusData<RequestCategory>.idle());

  final IRequestCategoryService _service;

  Future<void> submit(RequestCategoryCreateDto dto) async {
    emit(FormStatusData<RequestCategory>.loading());
    final result = await _service.create(dto);
    result.fold(
      (l) {
        emit(FormStatusData<RequestCategory>.error(error: l));
      },
      (r) {
        emit(FormStatusData<RequestCategory>.success(data: r));
      },
    );
  }

  void clear() {
    emit(FormStatusData<RequestCategory>.idle());
  }
}
