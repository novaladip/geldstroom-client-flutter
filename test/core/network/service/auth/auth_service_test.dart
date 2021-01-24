import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';
import 'package:geldstroom/core/network/model/error_model.dart';
import 'package:geldstroom/core/network/service/auth/auth_service.dart';
import 'package:geldstroom/shared/common/config/config.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  group('AuthService', () {
    Dio dio;
    AuthService authService;
    DioAdapterMock dioAdapterMock;

    setUpAll(() async {
      DotEnv().env = {'mode': 'test'};
      dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
      dioAdapterMock = DioAdapterMock();
      dio.httpClientAdapter = dioAdapterMock;
      authService = AuthService(dio);
    });

    test('loginWithEmail when successful should return Right(String)',
        () async {
      final payload = {
        'accessToken':
            // ignore: lines_longer_than_80_chars
            'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAZ21haWwuY29tIiwiZXhwIjoxOTE5NTk1Nzg0LCJpZCI6ImZlYWYxYzA0LTZhNDYtNGRhNi04NDExLTE2OWNiMWYxZjY5ZSIsImlzQWRtaW4iOnRydWV9.Ymu_8Ivv3dtcGRqGMDgAfyldP8-Cfw7TZ-GdjaVDpxvcAMF_phYBCVFA2X4-O8lxOZijIqreYj-8gbxLN4U3Aw'
      };
      final httpResponse = buildResponseBody(payload: payload);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final dto = LoginDto(email: 'john@email.com', password: 'password');
      final result = await authService.loginWithEmail(dto);

      result.fold(
        (l) {
          expect(l, null);
        },
        (r) {
          expect(r, payload['accessToken']);
        },
      );
    });

    test('loginWithEmail when failed should return Left(ServerError)',
        () async {
      final payload = {
        'message': 'Validation failed',
        'errorCode': UserErrorCode.validationError,
        'error': {'email': 'Invalid email address'}
      };
      final httpResponse = buildResponseBody(payload: payload, statusCode: 400);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final dto = LoginDto(email: 'john@email.com', password: 'password');
      final result = await authService.loginWithEmail(dto);

      result.fold(
        (l) {
          expect(l, ServerError.fromJson(payload));
        },
        (r) {
          expect(r, null);
        },
      );
    });

    test(
        'register when failed should return Left(ServerError) '
        'base on error payload', () async {
      final payload = {
        'message': 'Validation failed',
        'errorCode': UserErrorCode.validationError,
        'error': {'email': 'Invalid email address'}
      };
      final httpResponse = buildResponseBody(payload: payload, statusCode: 400);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      final dto = RegisterDto(
        email: 'john@email.com',
        firstName: 'John',
        lastName: 'Doe',
        password: 'somepassword',
      );
      final result = await authService.register(dto);

      result.fold(
        (l) {
          expect(l, ServerError.fromJson(payload));
        },
        (r) {
          expect(r, null);
        },
      );
    });

    test('register when successful should return Right(None)', () async {
      final payload = {'message': 'register success'};
      final httpResponse = buildResponseBody(payload: payload);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      final dto = RegisterDto(
        email: 'john@email.com',
        firstName: 'John',
        lastName: 'Doe',
        password: 'somepassword',
      );
      final result = await authService.register(dto);

      result.fold(
        (l) {
          expect(l, null);
        },
        (r) {
          expect(r, None());
        },
      );
    });

    test('requestOtp when successful should return Right(None)', () async {
      final payload = {'message': 'code OTP has been send to your email'};
      final httpResponse = buildResponseBody(payload: payload);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      final result = await authService.requestOtp('john@email.com');
      result.fold(
        (l) => expect(l, null),
        (r) => expect(r, None()),
      );
    });

    test(
        'requestOtp when failed should return Left(ServerError) '
        'base on error payload', () async {
      final payload = {
        'message': 'Validation failed',
        'errorCode': UserErrorCode.validationError,
        'error': {'email': 'Invalid email address'}
      };
      final httpResponse = buildResponseBody(payload: payload, statusCode: 400);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      final result = await authService.requestOtp('john@email.com');
      result.fold(
        (l) => expect(l, ServerError.fromJson(payload)),
        (r) => expect(r, null),
      );
    });

    test('resetPassword when successful should return Right(None)', () async {
      final payload = {'message': 'your password has been updated'};
      final httpResponse = buildResponseBody(payload: payload);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      final result = await authService.resetPassword(PasswordResetDto(
        email: 'john@email.com',
        otp: '123456',
        password: 'johnpassword',
      ));
      result.fold(
        (l) => expect(l, null),
        (r) => expect(r, None()),
      );
    });

    test(
        'resetPassword when failed should return Left(ServerError) '
        'base on error payload', () async {
      final payload = {
        'message': 'Validation failed',
        'errorCode': UserErrorCode.validationError,
        'error': {'email': 'Invalid email address'}
      };
      final httpResponse = buildResponseBody(payload: payload, statusCode: 400);
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      final result = await authService.resetPassword(PasswordResetDto(
        email: 'john@email.com',
        otp: '123456',
        password: 'johnpassword',
      ));
      result.fold(
        (l) => expect(l, ServerError.fromJson(payload)),
        (r) => expect(r, null),
      );
    });
  });
}
