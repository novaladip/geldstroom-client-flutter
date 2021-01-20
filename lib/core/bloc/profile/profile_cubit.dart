import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/model/model.dart';
import '../../network/service/service.dart';
import '../bloc.dart';

part 'profile_cubit.freezed.dart';
part 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._service,
    this._authCubit,
  ) : super(ProfileState.loadInProgress()) {
    _authCubit.listen((state) {
      if (state is AuthStateUnauthenticated) {
        clear();
      }
    });
  }

  final IUserService _service;
  final AuthCubit _authCubit;

  Future<void> fetch() async {
    emit(ProfileState.loadInProgress());
    final result = await _service.getProfile();
    result.fold(
      (l) => emit(ProfileState.loadFailure(l)),
      (r) => emit(ProfileState.loadSucess(r)),
    );
  }

  void clear() {
    emit(ProfileState.loadInProgress());
  }
}
