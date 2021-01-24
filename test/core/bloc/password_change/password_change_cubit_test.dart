import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/password_change/password_change_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockIUSerService extends Mock implements IUserService {}

void main() {
  group('PasswordChangeCubit', () {
    IUserService service;
    PasswordChangeCubit subject;

    final dto = PasswordChangeDto(
      oldPassword: '123123',
      password: '321321',
      passwordConfirmation: '321321',
    );
    final serverError = ServerError.networkError();
    final stateIdle = PasswordChangeState(FormStatus.idle());
    final stateLoading = PasswordChangeState(FormStatus.loading());
    final stateSuccess = PasswordChangeState(FormStatus.success());
    final stateError =
        PasswordChangeState(FormStatus.error(error: serverError));

    setUp(() {
      service = MockIUSerService();
      subject = PasswordChangeCubit(service);
    });

    tearDown(() {
      subject.close();
    });

    test('initial state', () {
      expect(subject.state, stateIdle);
    });

    blocTest<PasswordChangeCubit, PasswordChangeState>(
      'clear',
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [stateIdle],
    );

    group('submit', () {
      blocTest<PasswordChangeCubit, PasswordChangeState>(
        'when successful',
        build: () {
          when(service.changePassword(dto))
              .thenAnswer((_) async => Right(None()));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [stateLoading, stateSuccess, stateIdle],
      );

      blocTest<PasswordChangeCubit, PasswordChangeState>(
        'when failure',
        build: () {
          when(service.changePassword(dto))
              .thenAnswer((_) async => Left(serverError));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [stateLoading, stateError],
      );
    });
  });
}
