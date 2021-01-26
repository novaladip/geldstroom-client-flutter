import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/model/model.dart';
import '../../network/service/service.dart';
import '../bloc.dart';

part 'request_category_cubit.freezed.dart';
part 'request_category_state.dart';

@lazySingleton
class RequestCategoryCubit extends Cubit<RequestCategoryState> {
  RequestCategoryCubit(
    this._service,
    this._authCubit,
  ) : super(RequestCategoryState.initial()) {
    _authCubit.listen((state) {
      // clear state when auth state is unauthenticated
      if (state is AuthStateUnauthenticated) {
        emit(RequestCategoryState.initial());
      }
    });
  }

  final IRequestCategoryService _service;
  final AuthCubit _authCubit;

  Future<void> fetch() async {
    emit(state.copyWith(status: FetchStatus.loadInProgress()));
    final result = await _service.getAll();
    result.fold(
      (l) {
        emit(state.copyWith(status: FetchStatus.loadFailure(error: l)));
      },
      (r) {
        emit(
          state.copyWith(
            status: FetchStatus.loadSuccess(),
            data: r,
          ),
        );
      },
    );
  }

  void clear() {
    emit(RequestCategoryState.initial());
  }
}
