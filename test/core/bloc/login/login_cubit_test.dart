import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/login/login_cubit.dart';
import 'package:geldstroom/core/network/dto/login_dto.dart';
import 'package:geldstroom/core/network/model/status_model.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/core/network/service/auth/auth_service.dart';
import 'package:geldstroom/shared/common/utils/jwt_ops/jwt_ops.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements IAuthService {}

class MockJwtOps extends Mock implements JwtOps {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  group('LoginCubit', () {
    MockAuthService authService;
    MockAuthCubit authCubit;
    MockJwtOps jwtOps;
    final dto = LoginDto(email: 'john@email.com', password: 'somepassword');

    setUp(() {
      authService = MockAuthService();
      authCubit = MockAuthCubit();
      jwtOps = MockJwtOps();
    });

    blocTest<LoginCubit, LoginState>(
      'emits LoginState with status [loading, success] when successful',
      build: () {
        when(authService.loginWithEmail(dto))
            .thenAnswer((_) async => Right('Sometoken'));
        return LoginCubit(
          authService,
          authCubit,
          jwtOps,
        );
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        LoginState(status: FormStatus.loading()),
        LoginState(status: FormStatus.success()),
      ],
      verify: (_) {
        verify(authCubit.loggedIn('Sometoken'));
        verify(jwtOps.persistToken('Sometoken'));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits LoginState with status [loading, error] when failed',
      build: () {
        when(authService.loginWithEmail(dto))
            .thenAnswer((_) async => Left(ServerError.networkError()));
        return LoginCubit(
          authService,
          authCubit,
          jwtOps,
        );
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        LoginState(status: FormStatus.loading()),
        LoginState(status: FormStatus.error(error: ServerError.networkError()))
      ],
    );
  });
}
