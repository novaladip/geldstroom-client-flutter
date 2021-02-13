import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../network/model/model.dart';

part 'form_none_cubit.freezed.dart';
part 'form_none_state.dart';

typedef FetchFunction<DTO> = Future<Either<ServerError, None>> Function(
  DTO dto,
);

class FormNoneCubit<DTO> extends Cubit<FormNoneState> {
  FormNoneCubit(
    this._call,
  ) : super(FormNoneState.initial());

  final FetchFunction<DTO> _call;

  Future<void> submit(DTO dto) async {
    emit(FormNoneState(status: FormStatus.loading()));

    final result = await _call(dto);
    result.fold(
      (l) {
        emit(FormNoneState(status: FormStatus.error(error: l)));
      },
      (r) {
        emit(FormNoneState(status: FormStatus.success()));
        emit(FormNoneState(status: FormStatus.idle()));
      },
    );
  }

  void clear() {
    emit(FormNoneState.initial());
  }
}
