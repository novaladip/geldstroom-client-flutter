import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/password_reset/password_reset_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements IAuthService {}

void main() {
  group('PasswordResetCubit', () {
    final dto = PasswordResetDto(
      email: 'john@email.com',
      otp: '123456',
      password: 'johnpassword',
    );

    IAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('initial PasswordResetCubit state', () {
      final cubit = PasswordResetCubit(authService);
      expect(cubit.state, PasswordResetState.initial());
    });

    blocTest<PasswordResetCubit, PasswordResetState>(
      'emits PasswordResetState with status [loading, success] when successful',
      build: () {
        when(authService.resetPassword(dto)).thenAnswer(
          (_) async => Right(None()),
        );
        return PasswordResetCubit(authService);
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        PasswordResetState(status: FormStatus.loading()),
        PasswordResetState(status: FormStatus.success()),
      ],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'emits PasswordResetState with status [loading, error] when failure',
      build: () {
        when(authService.resetPassword(dto)).thenAnswer(
          (_) async => Left(ServerError.networkError()),
        );
        return PasswordResetCubit(authService);
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        PasswordResetState(status: FormStatus.loading()),
        PasswordResetState(
          status: FormStatus.error(
            error: ServerError.networkError(),
          ),
        ),
      ],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'emits PasswordResetState with status [idle] when clear()',
      build: () => PasswordResetCubit(authService),
      act: (cubit) => cubit.clear(),
      expect: [PasswordResetState.initial()],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'emits PasswordResetState with showAllTrue: true '
      'when changeShowAllForm(true)',
      build: () => PasswordResetCubit(authService),
      act: (cubit) => cubit.changeShowAllForm(true),
      expect: [
        PasswordResetState(
          status: FormStatus.idle(),
          showAllForm: true,
        )
      ],
    );
  });
}
