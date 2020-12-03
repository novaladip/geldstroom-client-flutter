import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../util/jwt_ops/jwt_ops.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final JwtOps _jwtOps;

  AuthCubit(this._jwtOps) : super(AuthState.initial());

  void appStarted() async {
    final token = await _jwtOps.getToken();
    if (token == null) {
      emit(AuthState.unauthenticated());
      return;
    }

    if (JwtDecoder.isExpired(token)) {
      emit(AuthState.unauthenticated());
      return;
    }

    loggedIn(token);
  }

  void loggedIn(String token) {
    _jwtOps.setDefaultAuthHeader(token);
    emit(AuthState.authenticated());
  }

  Future<void> loggedOut() async {
    _jwtOps.setDefaultAuthHeader('');
    await _jwtOps.removeToken();
    emit(AuthState.unauthenticated());
  }
}
