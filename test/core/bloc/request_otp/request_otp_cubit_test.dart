import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/request_otp/request_otp_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/core/network/service/auth/auth_service.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements IAuthService {}

void main() {
  group('RequestOtpCubit', () {
    IAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('initial RequestOtpState', () {
      final cubit = RequestOtpCubit(authService);
      expect(cubit.state, RequestOtpState.initial());
    });

    blocTest<RequestOtpCubit, RequestOtpState>(
      'emits RequestOtpState with status [loading, success] when successful',
      build: () {
        when(authService.requestOtp('john@email.com')).thenAnswer(
          (_) async => Right(None()),
        );
        return RequestOtpCubit(authService);
      },
      act: (cubit) => cubit.submit('john@email.com'),
      expect: [
        RequestOtpState(status: FormStatus.loading()),
        RequestOtpState(status: FormStatus.success()),
      ],
    );

    blocTest<RequestOtpCubit, RequestOtpState>(
      'emits RequestOtpState with status [loading, error] when failure',
      build: () {
        when(authService.requestOtp('john@email.com')).thenAnswer(
          (_) async => Left(ServerError.networkError()),
        );
        return RequestOtpCubit(authService);
      },
      act: (cubit) => cubit.submit('john@email.com'),
      expect: [
        RequestOtpState(status: FormStatus.loading()),
        RequestOtpState(
          status: FormStatus.error(error: ServerError.networkError()),
        ),
      ],
    );

    blocTest<RequestOtpCubit, RequestOtpState>(
      'emits RequestOtpState with status [idle] when clear()',
      build: () => RequestOtpCubit(authService),
      act: (cubit) => cubit.clear(),
      expect: [RequestOtpState.initial()],
    );
  });
}
