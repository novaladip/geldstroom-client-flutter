import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../network/model/model.dart';

part 'form_cubit.freezed.dart';
part 'form_state.dart';

typedef FetchFunction<DTO> = Future<Either<ServerError, None>> Function(
  DTO dto,
);

class FormCubit<DTO> extends Cubit<FormState> {
  FormCubit(
    this._call,
  ) : super(FormState.initial());

  final FetchFunction<DTO> _call;

  Future<void> submit(DTO dto) async {
    emit(FormState(status: FormStatus.loading()));

    final result = await _call(dto);
    result.fold(
      (l) {
        emit(FormState(status: FormStatus.error(error: l)));
      },
      (r) {
        emit(FormState(status: FormStatus.success()));
      },
    );
  }

  void clear() {
    emit(FormState.initial());
  }
}
