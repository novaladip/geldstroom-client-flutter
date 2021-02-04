import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/core/network/service/transaction/transaction_service.dart';
import 'package:geldstroom/shared/common/config/config.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper_tests/tranasction_json.dart';
import '../../../../test_helper.dart';
import 'json.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  group('TransactionService', () {
    Dio dio;
    TransactionService service;
    DioAdapterMock dioAdapterMock;

    setUp(() {
      DotEnv().env = {'mode': 'test'};
      dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
      dioAdapterMock = DioAdapterMock();
      dio.httpClientAdapter = dioAdapterMock;
      service = TransactionService(dio);
    });

    group('getBalance', () {
      test('when successful', () async {
        final payload = {
          'income': 20000,
          'expense': 10000,
        };
        final httpResponse = buildResponseBody(payload: payload);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final dto = BalanceFilterDto.weekly();
        final result = await service.getBalance(dto);
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, TransactionTotal.fromJson(payload));
          },
        );
      });

      test('when failure', () async {
        final httpResponse = buildResponseBody(
          payload: null,
          statusCode: null,
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final dto = BalanceFilterDto.weekly();
        final result = await service.getBalance(dto);
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

    group('getBalanceReport', () {
      test('when successful', () async {
        final httpResponse =
            buildResponseBody(payload: TransactionJson.balanceReport);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final dto = BalanceFilterDto.weekly();
        final result = await service.getBalanceReport(dto);
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(
              r,
              BalanceReport.fromJson(TransactionJson.balanceReport),
            );
          },
        );
      });

      test('when failure', () async {
        final httpResponse = buildResponseBody(
          payload: null,
          statusCode: null,
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final dto = BalanceFilterDto.weekly();
        final result = await service.getBalanceReport(dto);
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

    group('getTransaction', () {
      test('when successful', () async {
        final httpResponse = buildResponseBody(payload: getTransactionJson);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final dto = TransactionFilterDto.monthly();
        final result = await service.getTransactions(dto);
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, isA<List<Transaction>>());
            expect(r.length, getTransactionJson.length);
            for (var i = 0; i < r.length; i++) {
              expect(r[i], Transaction.fromJson(getTransactionJson[i]));
            }
          },
        );
      });
      test('when failure', () async {
        final httpResponse = buildResponseBody(
          payload: null,
          statusCode: null,
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final dto = TransactionFilterDto.weekly();
        final result = await service.getTransactions(dto);
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

    group('create', () {
      test('when successful', () async {
        final payload = getTransactionJson[0];
        final httpResponse = buildResponseBody(payload: payload);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await service.create(TransactionCreateDto(
          amount: 123123,
          categoryId: '123-123-123',
          description: '',
          type: 'EXPENSE',
        ));
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, Transaction.fromJson(payload));
          },
        );
      });
      test('when failure', () async {
        final httpResponse = buildResponseBody(payload: null, statusCode: 500);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        final result = await service.create(TransactionCreateDto(
          amount: 123123,
          categoryId: '123-123-123',
          description: '',
          type: 'EXPENSE',
        ));
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

    group('update', () {
      test('when successful', () async {
        final transaction = Transaction.fromJson(getTransactionJson[0]);
        final httpResponse = buildResponseBody(payload: getTransactionJson[0]);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final dto = TransactionEditDto(
          id: transaction.id,
          amount: transaction.amount,
          type: transaction.type,
          categoryId: transaction.category.id,
          description: transaction.description,
        );
        final result = await service.edit(dto);
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, transaction);
          },
        );
      });

      test('when failure', () async {
        final httpResponse = buildResponseBody(payload: null, statusCode: null);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final dto = TransactionEditDto(
          id: '1',
          amount: 123,
          type: 'INCOME',
          categoryId: '1',
          description: 'some description',
        );
        final result = await service.edit(dto);
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
    group('deleteOneById', () {
      test('return Right(None) when successful', () async {
        final httpResponse = buildResponseBody(payload: {'message': 'ok'});
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await service.deleteOneById('1');
        result.fold(
          (l) {
            expect(l, null);
          },
          (r) {
            expect(r, None());
          },
        );
      });

      test('return Left(ServerError) when failure', () async {
        final httpResponse = buildResponseBody(
            payload: {'message': 'internal server error'}, statusCode: 501);
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await service.deleteOneById('1');
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
