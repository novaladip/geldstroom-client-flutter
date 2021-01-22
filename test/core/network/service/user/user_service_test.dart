import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/common/config/env.appconfig.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper_tests/profile_json.dart';
import '../../../../test_helper.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  DotEnv().env = {'mode': 'test'};
  group('UserService', () {
    UserService subject;
    DioAdapterMock dioAdapterMock;
    setUp(() {
      final dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
      dioAdapterMock = DioAdapterMock();
      dio.httpClientAdapter = dioAdapterMock;
      subject = UserService(dio);
    });

    group('getProfile', () {
      test('when successful', () async {
        final httpResponse = buildResponseBody(payload: profileJson);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await subject.getProfile();
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, Profile.fromJson(profileJson));
          },
        );
      });

      test('when failure', () async {
        final httpResponse = buildResponseBody(
          payload: {'message': 'internal server error'},
          statusCode: 500,
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await subject.getProfile();
        result.fold(
          (l) {
            expect(l, ServerError.unknownError());
          },
          (r) {
            expect(r, null);
          },
        );
      });
    });

    group('changePassword', () {
      test('when successful', () async {
        final dto = ChangePasswordDto(
          oldPassword: '123123',
          password: '321321',
          passwordConfirmation: '321321',
        );
        final httpResponse = buildResponseBody(
          payload: {'message': 'Password successfully changed'},
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await subject.changePassword(dto);
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, None());
          },
        );
      });

      test('when failure', () async {
        final dto = ChangePasswordDto(
          oldPassword: '123123',
          password: '321321',
          passwordConfirmation: '321321',
        );
        final httpResponse = buildResponseBody(
          payload: {'message': 'internal server error'},
          statusCode: 500,
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await subject.changePassword(dto);
        result.fold(
          (l) {
            expect(l, ServerError.unknownError());
          },
          (r) {
            expect(r, null);
          },
        );
      });
    });
  });
}
