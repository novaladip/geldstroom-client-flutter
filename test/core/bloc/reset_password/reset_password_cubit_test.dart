import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/reset_password/reset_password_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements IAuthService {}

void main() {
  group('ResetPasswordCubit', () {
    final dto = ResetPasswordDto(
      email: 'john@email.com',
      otp: '123456',
      password: 'johnpassword',
    );

    IAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('initial ResetPasswordCubit state', () {
      final cubit = ResetPasswordCubit(authService);
      expect(cubit.state, ResetPasswordState.initial());
    });

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits ResetPasswordState with status [loading, success] when successful',
      build: () {
        when(authService.resetPassword(dto)).thenAnswer(
          (_) async => Right(None()),
        );
        return ResetPasswordCubit(authService);
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        ResetPasswordState(status: FormStatus.loading()),
        ResetPasswordState(status: FormStatus.success()),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits ResetPasswordState with status [loading, error] when failure',
      build: () {
        when(authService.resetPassword(dto)).thenAnswer(
          (_) async => Left(ServerError.networkError()),
        );
        return ResetPasswordCubit(authService);
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        ResetPasswordState(status: FormStatus.loading()),
        ResetPasswordState(
          status: FormStatus.error(
            error: ServerError.networkError(),
          ),
        ),
      ],
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits ResetPasswordState with status [idle] when clear()',
      build: () => ResetPasswordCubit(authService),
      act: (cubit) => cubit.clear(),
      expect: [ResetPasswordState.initial()],
    );
  });
}
