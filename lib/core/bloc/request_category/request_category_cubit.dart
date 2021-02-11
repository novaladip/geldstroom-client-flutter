import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../bloc_base/bloc_base.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';
import '../bloc.dart';

part 'request_category_cubit.freezed.dart';
part 'request_category_state.dart';

@lazySingleton
class RequestCategoryCubit extends Cubit<RequestCategoryState> {
  RequestCategoryCubit(
    this._service, {
    @required AuthCubit authCubit,
    @required RequestCategoryCreateCubit requestCategoryCreateCubit,
    @required RequestCategoryDeleteCubit requestCategoryDeleteCubit,
  }) : super(RequestCategoryState.initial()) {
    authCubit.listen(_authCubitListener);
    requestCategoryCreateCubit.listen(_createListener);
    requestCategoryDeleteCubit.listen(_deleteListener);
  }

  void _authCubitListener(AuthState state) {
    // clear state when auth state is unauthenticated
    if (state is AuthStateUnauthenticated) {
      clear();
    }
  }

  // listen for RequestCategoryDeleteCubit
  void _deleteListener(DeleteState state) {
    // call _onDelete everytime there is a new id in onDeleteSuccessIds
    if (state.shouldListenDeleteSuccess(_prevDeleteState)) {
      _onDelete(state.onDeleteSuccessIds[0]);
    }
    // update _prevDeleteState value
    _prevDeleteState = state;
  }

  // listen for RequestCategoryCreateCubit
  void _createListener(FormStatusData<RequestCategory> state) {
    // call _add every time create success occurred
    state.maybeWhen(
      orElse: () {},
      success: _add,
    );
  }

  var _prevDeleteState = DeleteState.initial();
  final IRequestCategoryService _service;

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

  void _onDelete(String requestCategoryId) {
    final newState = state.copyWith(
      data: state.data.where((data) => data.id != requestCategoryId).toList(),
    );

    emit(newState);
  }

  void _add(RequestCategory item) {
    emit(state.copyWith(data: [item, ...state.data]));
  }

  void clear() {
    emit(RequestCategoryState.initial());
  }
}
