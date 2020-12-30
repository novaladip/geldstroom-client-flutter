import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/register/register_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements IAuthService {}

void main() {
  group('RegisterCubit', () {
    final dto = RegisterDto(
      email: 'john@email.com',
      password: 'johnpassword',
      firstName: 'john',
      lastName: 'doe',
    );
    IAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('initial RegisterState', () {
      final cubit = RegisterCubit(authService);
      expect(cubit.state, RegisterState.initial());
    });

    blocTest<RegisterCubit, RegisterState>(
      'emits RegisterState with status [loading, success] when successful',
      build: () {
        when(authService.register(dto)).thenAnswer(
          (_) async => Right(None()),
        );
        return RegisterCubit(authService);
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        RegisterState(status: FormStatus.loading()),
        RegisterState(status: FormStatus.success()),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits RegisterState with status [loading, error] when failed',
      build: () {
        when(authService.register(dto)).thenAnswer(
          (_) async => Left(ServerError.networkError()),
        );
        return RegisterCubit(authService);
      },
      act: (cubit) => cubit.submit(dto),
      expect: [
        RegisterState(status: FormStatus.loading()),
        RegisterState(
          status: FormStatus.error(error: ServerError.networkError()),
        ),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits RegisterState with status [idle] when clear() ',
      build: () => RegisterCubit(authService),
      act: (cubit) => cubit.clear(),
      expect: [RegisterState.initial()],
    );
  });
}
