// ignore_for_file: lines_longer_than_80_chars
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/common/config/config.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper_tests/dio.dart';
import '../../../../helper_tests/request_category_json.dart';
import '../../../../test_helper.dart';

void main() {
  group('RequestCategoryService', () {
    RequestCategoryService service;
    Dio dio;
    HttpClientAdapter dioAdapterMock;

    setUp(() {
      DotEnv().env = {'mode': 'test'};
      dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
      dioAdapterMock = DioAdapterMock();
      dio.httpClientAdapter = dioAdapterMock;
      service = RequestCategoryService(dio);
    });

    group('getAll', () {
      test('when successful', () async {
        final payload = RequestCategoryJson.list;
        final requestCategoryList =
            payload.map((json) => RequestCategory.fromJson(json)).toList();
        final httpResponse = buildResponseBody(payload: payload);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await service.getAll();
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, requestCategoryList);
          },
        );
      });

      test('when failure', () async {
        final httpResponse = buildResponseBody(
            payload: {'message': 'Internal server error'}, statusCode: 500);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await service.getAll();
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

    group('create', () {
      final dto = RequestCategoryCreateDto(
        name: RequestCategoryJson.list[0]['name'],
        description: RequestCategoryJson.list[0]['description'],
      );
      test('when successful', () async {
        final payload = RequestCategoryJson.list[0];
        final httpResponse = buildResponseBody(payload: payload);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await service.create(dto);
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, RequestCategory.fromJson(RequestCategoryJson.list[0]));
          },
        );
      });

      test('when failure', () async {
        final httpResponse = buildResponseBody(
            payload: {'message': 'Internal server error'}, statusCode: 500);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await service.create(dto);
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
