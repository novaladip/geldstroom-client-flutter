import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/core/network/service/category/category_service.dart';
import 'package:geldstroom/shared/common/config/config.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper_tests/dio.dart';
import '../../../../test_helper.dart';

void main() {
  group('CategoryService', () {
    Dio dio;
    CategoryService service;
    DioAdapterMock dioAdapterMock;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
      dioAdapterMock = DioAdapterMock();
      dio.httpClientAdapter = dioAdapterMock;
      service = CategoryService(dio);
    });
    test('should return Right<List<Transaction>> when successful', () async {
      final httpResponse = buildResponseBody(
        payload: [
          {
            'id': '231-32131',
            'name': 'Food',
            'iconURL': 'https://img.url',
            'credit': 'Created by somebody',
          }
        ],
      );

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final result = await service.fetchCategories();
      result.fold(
        (l) {
          expect(l, null);
        },
        (r) {
          expect(r, isA<List<TransactionCategory>>());
        },
      );
    });

    test('should return Left<ServerError> when failure', () async {
      final httpResponse = buildResponseBody(payload: null, statusCode: null);

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final result = await service.fetchCategories();
      result.fold(
        (l) {
          expect(l, ServerError.networkError());
        },
        (r) {
          expect(r, null);
        },
      );
    });
  });
}
